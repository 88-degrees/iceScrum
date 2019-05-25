/*
 * Copyright (c) 2012 Kagilum.
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
 * Colin Bontemps (cbontemps@kagilum.com)
 *
 */

class RestUrlMappings {

    static mappings = {

        "/ws/version" {
            action = [GET: 'version']
            controller = 'scrumOS'
        }
        // User
        "/ws/user" { // Admin
            controller = 'user'
            action = [GET: 'index', POST: 'save']
        }
        "/ws/user/$id" {
            controller = 'user'
            action = [GET: 'show', PUT: 'update', POST: 'update']
            constraints {
                id(matches: /\d*/)
            }
        }
        "/ws/user/$id/activities" {
            controller = 'user'
            action = [GET: 'activities']
            constraints {
                id(matches: /\d*/)
            }
        }
        "/ws/user/$id/replaceBy/$substitutedBy" { // Admin -- ReplaceBy instead of substitutedBy for the exposed API as it is more user friendly
            controller = 'user'
            action = [DELETE: 'delete']
            constraints {
                substitutedBy(matches: /\d*/)
            }
        }
        "/ws/user/current" {
            controller = 'user'
            action = 'current'
        }
        // Team (if user is admin all teams ELSE teams where user is owner
        "/ws/team" {
            controller = 'team'
            action = [GET: 'index']
        }
        "/ws/team/$id" {
            controller = 'team'
            action = [GET: 'show']
            constraints {
                id(matches: /\d*/)
            }
        }
        // Team of a project
        "/ws/team/project/$project" {
            controller = 'team'
            action = [GET: 'showByProject']
            constraints {
                project(matches: /[0-9A-Z]*/)
            }
            method = 'GET'
        }
        // Project (token must be admin for index)
        "/ws/project" {
            controller = 'project'
            action = [GET: 'index', POST: 'save']
        }
        // (token must be admin if $id != currentUser.id // id can be string or int
        "/ws/project/user/$id?" {
            controller = 'project'
            action = 'listByUser'
            method = 'GET'
        }
        // (token must be admin is $id != currentUser.id
        "/ws/project/user/$id/$role" {
            controller = 'project'
            action = 'listByUserAndRole'
            constraints {
                id(matches: /\d*/)
                role(inList: ['scrumMaster', 'productOwner', 'stakeHolder', 'teamMember'])
            }
            method = 'GET'
        }
        "/ws/project/$project" {
            controller = 'project'
            action = [GET: 'show', PUT: 'update', POST: 'update', DELETE: 'delete']
            constraints {
                project(matches: /[0-9A-Z]*/)
            }
        }
        "/ws/project/$project/export/$format?" {
            controller = 'project'
            action = 'export'
            constraints {
                project(matches: /[0-9A-Z]*/)
                format(inList: ['zip', 'xml'])
            }
            method = 'GET'
        }
        // Resources
        "/ws/project/$project/$controller" {
            action = [GET: 'index', POST: 'save']
            constraints {
                project(matches: /[0-9A-Z]*/)
                controller(inList: ['hook', 'story', 'acceptanceTest', 'feature', 'backlog', 'actor', 'task', 'release', 'sprint', 'timeBoxNotesTemplate'])
            }
        }
        "/ws/project/$project/$controller/$id" {
            action = [GET: 'show', PUT: 'update', POST: 'update', DELETE: 'delete']
            constraints {
                project(matches: /[0-9A-Z]*/)
                controller(inList: ['hook', 'story', 'acceptanceTest', 'feature', 'backlog', 'actor', 'task', 'release', 'sprint', 'timeBoxNotesTemplate'])
                id(matches: /\d*/)
            }
        }
        // Comments
        "/ws/project/$project/comment/$type" {
            controller = 'comment'
            action = [GET: 'index']
            constraints {
                project(matches: /[0-9A-Z]*/)
                type(inList: ['story', 'task'])
            }
        }
        "/ws/project/$project/comment/$type/$commentable" {
            controller = 'comment'
            action = [GET: 'index', POST: 'save']
            constraints {
                project(matches: /[0-9A-Z]*/)
                type(inList: ['story', 'task'])
                commentable(matches: /\d*/)
            }
        }
        "/ws/project/$project/comment/$type/$commentable/$id" {
            controller = 'comment'
            action = [GET: 'show', PUT: 'update', POST: 'update', DELETE: 'delete']
            constraints {
                project(matches: /[0-9A-Z]*/)
                type(inList: ['story', 'task'])
                id(matches: /\d*/)
                commentable(matches: /\d*/)
            }
        }
        // Story nested actions
        "/ws/project/$project/story/$id/$action" {
            controller = 'story'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                action(inList: ['accept', 'returnToSandbox', 'turnIntoFeature', 'turnIntoTask', 'copy', 'plan', 'unPlan', 'shiftToNextSprint', 'done', 'unDone'])
            }
            method = 'POST'
        }
        "/ws/project/$project/story/$id/$action" {
            controller = 'story'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                action(inList: ['activities'])
            }
            method = 'GET'
        }
        // Story filter by backlog / actor / sprint / feature
        "/ws/project/$project/story/$type/$typeId" {
            controller = 'story'
            action = 'index'
            constraints {
                project(matches: /[0-9A-Z]*/)
                type(inList: ['backlog', 'actor', 'sprint', 'feature'])
                typeId(matches: /\d*/)
            }
            method = 'GET'
        }
        "/ws/project/$project/story/backlog/$id/print/$format" {
            controller = 'backlog'
            constraints {
                project(matches: /[0-9A-Z]*/)
                action(inList: ['printByBacklog'])
                id(matches: /\d*/)
            }
            method = 'GET'
        }
        "/ws/project/$project/story/backlog/$id/printPostits" {
            controller = 'story'
            action = 'printPostitsByBacklog'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
            }
        }
        "/ws/project/$project/story/sprint/$id/printPostits" {
            controller = 'story'
            action = 'printPostitsBySprint'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
            }
        }
        "/ws/project/$project/task/sprint/$id/printPostits" {
            controller = 'task'
            action = 'printPostitsBySprint'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
            }
        }
        // Feature nested actions
        "/ws/project/$project/feature/$action" {
            controller = 'feature'
            constraints {
                project(matches: /[0-9A-Z]*/)
                action(inList: ['print'])
            }
            method = 'GET'
        }
        "/ws/project/$project/feature/$id/$action" {
            controller = 'feature'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                action(inList: ['activities'])
            }
            method = 'GET'
        }
        // release nested actions
        "/ws/project/$project/release/$id/$action" {
            controller = 'release'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                action(inList: ['activate', 'close', 'unPlan', 'reactivate'])
            }
            method = 'POST'
        }
        // Plan a release with a plannedVelocity
        "/ws/project/$project/release/$id/autoPlan/$plannedVelocity" {
            controller = 'release'
            action = [POST: 'autoPlan']
            constraints {
                id(matches: /\d*/)
                project(matches: /[0-9A-Z]*/)
                plannedVelocity(matches: /\d*/)
            }
        }
        // Generate release notes
        "/ws/project/$project/release/$id/releaseNotes/$templateId" {
            controller = 'timeBoxNotesTemplate'
            action = [GET: 'releaseNotes']
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d+/)
                templateId(matches: /\d+/)
            }
            method = 'GET'
        }
        // Sprint nested actions
        "/ws/project/$project/sprint/$id/$action" {
            controller = 'sprint'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                action(inList: ['activate', 'reactivate', 'close', 'unPlan', 'copyRecurrentTasks'])
            }
            method = 'POST'
        }
        // Plan a sprint with a plannedVelocity
        "/ws/project/$project/sprint/$id/autoPlan/$plannedVelocity" {
            controller = 'sprint'
            action = [POST: 'autoPlan']
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                plannedVelocity(matches: /\d*/)
            }
        }
        // Generate sprint for a release
        "/ws/project/$project/sprint/generateSprints/$releaseId" {
            controller = 'sprint'
            action = [POST: 'generateSprints']
            constraints {
                project(matches: /[0-9A-Z]*/)
                releaseId(matches: /\d*/)
            }
        }
        // Sprint filter by release
        "/ws/project/$project/sprint/release/$releaseId" {
            controller = 'sprint'
            action = [GET: 'index']
            type = 'release'
            constraints {
                project(matches: /[0-9A-Z]*/)
                releaseId(matches: /\d*/)
            }
        }
        // Generate sprint notes
        "/ws/project/$project/sprint/$id/sprintNotes/$templateId" {
            controller = 'timeBoxNotesTemplate'
            action = [GET: 'sprintNotes']
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d+/)
                templateId(matches: /\d+/)
            }
        }
        // Tasks nested actions
        "/ws/project/$project/task/$id/$action" {
            controller = 'task'
            constraints {
                project(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
                action(inList: ['makeStory', 'take', 'unassign', 'copy'])
            }
            method = 'POST'
        }
        // Task filter by sprint / story
        "/ws/project/$project/task/$type/$id" {
            controller = 'task'
            action = [GET: 'index']
            constraints {
                project(matches: /[0-9A-Z]*/)
                type(inList: ['sprint', 'story'])
                id(matches: /\d*/)
            }
        }
        // Filter acceptanceTests by story
        "/ws/project/$project/acceptanceTest/story/$parentStory" {
            controller = 'acceptanceTest'
            action = [GET: 'index']
            constraints {
                project(matches: /[0-9A-Z]*/)
                parentStory(matches: /\d*/)
            }
        }
        // Portfolio
        "/ws/portfolio" {
            action = [GET: 'index', POST: 'save']
            constraints {
                controller(inList: ['hook', 'portfolio'])
            }
        }
        "/ws/portfolio/$portfolio/$controller/$id?" {
            action = [GET: 'show', PUT: 'update', POST: 'update', DELETE: 'delete']
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
                controller(inList: ['hook', 'portfolio'])
                id(matches: /\d*/)
            }
        }
        // Hook
        "/ws/hook" {
            controller = 'hook'
            action = [GET: "index", POST: "save"]
        }
        "/ws/hook/$id" {
            controller = 'hook'
            action = [GET: "show", PUT: "update", DELETE: 'delete', POST: 'update']
            constraints {
                id(matches: /\d+(,\d+)*/)
            }
        }
    }
}
