/*
 * Copyright (c) 2015 Kagilum.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vbarrier@kagilum.com)
 * Nicolas Noullet (nnoullet@kagilum.com)
 *
 */
package org.icescrum.web.presentation.api

import grails.converters.JSON
import grails.plugin.springsecurity.annotation.Secured
import org.icescrum.core.domain.*
import org.icescrum.core.error.ControllerErrorHandler
import org.icescrum.core.utils.ServicesUtils

class TaskController implements ControllerErrorHandler {

    def springSecurityService
    def taskService

    @Secured('inProject() or (isAuthenticated() and stakeHolder())')
    def index(long id, long project, String type) {
        def tasks
        def options
        if (params.filter) {
            options = JSON.parse(params.filter)
        } else {
            options = [task: [:]]
            if (type == 'story') { //refactor with search and options
                options.task.parentStory = id
            } else if (type == 'sprint') {
                options.task.parentSprint = id
            }
        }
        tasks = Task.search(project, options)
        if (params.context) {
            tasks = tasks.findAll { Task task ->
                if (params.context.type == 'tag') {
                    def tag = params.context.id.toLowerCase()
                    return task.tags*.toLowerCase().contains(tag) || task.parentStory?.tags*.toLowerCase()?.contains(tag)
                } else if (task.parentStory) {
                    if (params.context.type == 'feature') {
                        return task.parentStory.feature?.id == params.context.id.toLong()
                    } else if (params.context.type == 'actor') {
                        return task.parentStory.actors.findAll { it.id == params.context.id.toLong() }
                    }
                }
                return true
            }
        }
        render(status: 200, contentType: 'application/json', text: tasks as JSON)
    }


    @Secured('inProject() or (isAuthenticated() and stakeHolder())')
    def show(long id, long project) {
        Task task = Task.withTask(project, id)
        render(status: 200, contentType: 'application/json', text: task as JSON)
    }

    @Secured('inProject() or (isAuthenticated() and stakeHolder())')
    def uid(int uid, long project) {
        Project _project = Project.withProject(project)
        Task task = Task.findByParentProjectAndUid(_project, uid)
        if (task) {
            params.id = task.id.toString()
            forward(action: "show")
        } else {
            render(status: 404)
        }
    }

    @Secured('inProject() and !archivedProject()')
    def save() {
        def taskParams = params.task
        if (!taskParams) {
            returnError(code: 'todo.is.ui.no.data')
            return
        }
        ['estimation', 'spent'].each { property ->
            if (taskParams[property] instanceof String) {
                try {
                    taskParams[property] = taskParams[property] in ['?', ""] ? null : taskParams[property].replace(/,/, '.').toFloat()
                } catch (NumberFormatException e) {
                    returnError(code: 'is.task.error.estimation.number')
                    return
                }
            }
        }
        if (!taskParams.backlog) {
            taskParams.backlog = taskParams.sprint
        }
        Task task = new Task()
        Task.withTransaction {
            cleanBeforeBindData(taskParams, ['parentStory', 'backlog', 'responsible'])
            def propertiesToBind = ['name', 'estimation', 'description', 'notes', 'color', 'parentStory', 'type', 'backlog', 'blocked']
            entry.hook(id: 'task-before-save', model: [task: task, propertiesToBind: propertiesToBind])
            bindData(task, taskParams, [include: propertiesToBind])
            taskService.save(task, springSecurityService.currentUser)
            task.tags = taskParams.tags instanceof String ? taskParams.tags.split(',') : (taskParams.tags instanceof String[] || taskParams.tags instanceof List) ? taskParams.tags : null
        }
        render(status: 201, contentType: 'application/json', text: task as JSON)
    }

    @Secured('inProject() and !archivedProject()')
    def update(long id, long project) {
        def taskParams = params.task
        if (!taskParams) {
            returnError(code: 'todo.is.ui.no.data')
            return
        }
        Task task = Task.withTask(project, id)
        User user = (User) springSecurityService.currentUser
        ['estimation', 'spent'].each { property ->
            if (taskParams[property] instanceof String) {
                try {
                    taskParams[property] = taskParams[property] in ['?', ""] ? null : taskParams[property].replace(/,/, '.').toFloat()
                } catch (NumberFormatException e) {
                    returnError(code: 'is.task.error.estimation.number')
                    return
                }
            }
        }
        def props = [:]
        Integer rank = taskParams.rank instanceof String ? taskParams.rank.toInteger() : taskParams.rank
        if (rank != null) {
            props.rank = rank
        }
        Integer state = taskParams.state instanceof String ? taskParams.state.toInteger() : taskParams.state
        if (state != null) {
            props.state = state
        }
        Task.withTransaction {
            cleanBeforeBindData(taskParams, ['parentStory', 'responsible'])
            def propertiesToBind = ['name', 'estimation', 'description', 'notes', 'color', 'parentStory', 'type', 'blocked']
            entry.hook(id: 'task-before-update', model: [task: task, propertiesToBind: propertiesToBind, propertiesEdited: props])
            bindData(task, taskParams, [include: propertiesToBind])
            if (taskParams.parentStory && !taskParams.type) {
                task.type = null
            } else if (taskParams.type && !taskParams.parentStory) {
                task.parentStory = null
            }
            task.tags = taskParams.tags instanceof String ? taskParams.tags.split(',') : (taskParams.tags instanceof String[] || taskParams.tags instanceof List) ? taskParams.tags : null
            taskService.update(task, user, false, props)
            render(status: 200, contentType: 'application/json', text: task as JSON)
        }
    }

    @Secured('inProject() and !archivedProject()')
    def delete() {
        List<Task> tasks = Task.withTasks(params)
        User user = (User) springSecurityService.currentUser
        Task.withTransaction {
            tasks.each {
                taskService.delete(it, user)
            }
        }
        def returnData = tasks.size() > 1 ? tasks.collect { [id: it.id] } : (tasks ? [id: tasks.first().id] : [:])
        withFormat {
            html {
                render(status: 200, text: returnData as JSON)
            }
            json {
                render(status: 204)
            }
        }
    }

    @Secured('inProject() and !archivedProject()')
    def makeStory(long id, long project) {
        Task task = Task.withTask(project, id)
        taskService.makeStory(task)
        render(status: 204)
    }

    @Secured('inProject() and !archivedProject()')
    def take(long id, long project) {
        Task task = Task.withTask(project, id)
        User user = (User) springSecurityService.currentUser
        Task.withTransaction {
            task.responsible = user
            taskService.update(task, user)
        }
        render(status: 200, contentType: 'application/json', text: task as JSON)
    }

    @Secured('inProject() and !archivedProject()')
    def unassign(long id, long project) {
        Task task = Task.withTask(project, id)
        User user = (User) springSecurityService.currentUser
        if (task.responsible?.id != user.id) {
            returnError(code: 'is.task.error.unassign.not.responsible')
            return
        }
        if (task.state == Task.STATE_DONE) {
            returnError(code: 'is.task.error.done')
            return
        }
        Task.withTransaction {
            taskService.update(task, user, false, [state: Task.STATE_WAIT, responsible: null])
        }
        render(status: 200, contentType: 'application/json', text: task as JSON)
    }

    @Secured('inProject() and !archivedProject()')
    def copy(long id, long project) {
        Task task = Task.withTask(project, id)
        User user = (User) springSecurityService.currentUser
        def copiedTask = taskService.copy(task, user)
        render(status: 200, contentType: 'application/json', text: copiedTask as JSON)
    }

    @Secured('inProject() and !archivedProject()')
    def daily(long project, int days) {
        days = days ?: 1

        def allTasks = Task.where {
            responsible.id == springSecurityService.currentUser.id &&
            parentProject.id == project &&
            backlog != null
        }.list().findAll {
            ((Sprint) it.backlog).state in [Sprint.STATE_INPROGRESS] // Doesn't work in the criteria because of the cast so it must be done after
        }

        def tasksByState = allTasks.groupBy { it.state }
        def tasksInProgress = tasksByState[Task.STATE_BUSY].findAll { !it.blocked }.sort { it.lastUpdated }
        def tasksDone = tasksByState[Task.STATE_DONE].findAll { it.doneDate > (new Date() - days) }
        def tasksBlocked = allTasks.findAll { it.blocked }.sort { it.lastUpdated }
        def tasksTodo = tasksByState[Task.STATE_WAIT].findAll { it.parentStory?.rank }
        def dailyByProject = [
                tasksInProgress: tasksInProgress,
                tasksBlocked   : tasksBlocked,
                tasksDone      : tasksDone,
                tasksTodo      : tasksTodo
        ]

        render(status: 200, contentType: 'application/json', text: dailyByProject as JSON)
    }

    @Secured('isAuthenticated()')
    def listByUser(Long projectId) {
        def userTasks = Task.where {
            responsible.id == springSecurityService.currentUser.id &&
            (projectId ? parentProject.id == projectId : true) &&
            (state in [Task.STATE_WAIT, Task.STATE_BUSY]) &&
            backlog != null
        }.list()
        def tasksByProject = userTasks.findAll {
            ((Sprint) it.backlog).state in [Sprint.STATE_WAIT, Sprint.STATE_INPROGRESS] // Doesn't work in the criteria because of the cast so it must be done after
        }.sort { -it.state }.take(8).groupBy {
            it.parentProject
        }.collect { project, tasks ->
            [project: [class: 'Project', id: project.id, pkey: project.pkey, name: project.name, preferences: [archived: project.preferences.archived]], tasks: tasks]
        }
        render(status: 200, contentType: 'application/json', text: tasksByProject as JSON)
    }

    @Secured('inProject() or (isAuthenticated() and stakeHolder())')
    def permalink(int uid, long project) {
        Project _project = Project.withProject(project)
        Task task = Task.findByParentProjectAndUid(_project, uid)
        if (task) {
            String uri = "/p/$_project.pkey/#/"
            if (task.backlog) {
                uri += "taskBoard/$task.backlog.id/task/$task.id"
            } else {
                def story = task.parentStory
                switch (story.state) {
                    case Story.STATE_SUGGESTED:
                        uri += "backlog/sandbox/story/$story.id"
                        break
                    case [Story.STATE_ACCEPTED, Story.STATE_ESTIMATED]:
                        uri += "backlog/backlog/story/$story.id"
                        break
                    default:
                        uri += "backlog/all/story/$story.id"
                }
                uri += "/tasks/task/$task.id"
            }
            redirect(uri: uri + (params.tab ? '/' + params.tab : ''))
        } else {
            redirect(controller: 'errors', action: 'error404')
        }
    }

    @Secured('inProject() or (isAuthenticated() and stakeHolder())')
    def colors(long project) {
        def results = Task.createCriteria().list() {
            eq("parentProject.id", project)
            projections {
                groupProperty "color"
                count "color", "colorSize"
            }
            order('colorSize', 'desc')
            maxResults(7)
        }?.collect { it[0] }
        render(status: 200, contentType: 'application/json', text: results as JSON)
    }

    @Secured('inProject() or (isAuthenticated() and stakeHolder())')
    def printPostitsBySprint(long project, long id) {
        Sprint sprint = Sprint.withSprint(project, id)
        Project _project = sprint.parentRelease.parentProject
        def tasks1 = []
        def tasks2 = []
        def first = 0
        def tasks = sprint.tasks.sort { Task task -> task.parentStory }
        if (!tasks) {
            returnError(code: 'is.report.error.no.data')
        } else {
            tasks.each { _task ->
                def task = [
                        name       : _task.name,
                        id         : _task.uid,
                        state      : message(code: grailsApplication.config.icescrum.resourceBundles.taskStates[_task.state]),
                        description: _task.description,
                        notes      : ServicesUtils.textileToHtml(_task.notes),
                        sprint     : g.message(code: 'is.sprint') + " " + ((Sprint) _task.backlog).index,
                        taskColor  : _task.color,
                        permalink  : _task.permalink,
                        story      : _task.parentStory ? _task.parentStory.name : null,
                        estimation : _task.estimation,
                        type       : _task.parentStory ? null : message(code: grailsApplication.config.icescrum.resourceBundles.taskTypes[_task.type])
                ]
                if (first == 0) {
                    tasks1 << task
                    first = 1
                } else {
                    tasks2 << task
                    first = 0
                }

            }
            renderReport('tasks', 'PDF', [[project: _project.name, tasks1: tasks1 ?: null, tasks2: tasks2 ?: null]], _project.name + '-' + g.message(code: 'is.sprint') + "-" + sprint.index)
        }
    }
}
