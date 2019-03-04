%{--
- Copyright (c) 2015 Kagilum SAS
-
- This file is part of iceScrum.
-
- iceScrum is free software: you can redistribute it and/or modify
- it under the terms of the GNU Affero General Public License as published by
- the Free Software Foundation, either version 3 of the License.
-
- iceScrum is distributed in the hope that it will be useful,
- but WITHOUT ANY WARRANTY; without even the implied warranty of
- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- GNU General Public License for more details.
-
- You should have received a copy of the GNU Affero General Public License
- along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
-
- Authors:
-
- Vincent Barrier (vbarrier@kagilum.com)
- Nicolas Noullet (nnoullet@kagilum.com)
- Colin Bontemps (cbontemps@kagilum.com)
--}%
<is:window windowDefinition="${windowDefinition}">
    <div class="card card-view sprint-state-{{ sprint.state }}"
         ng-if="sprint">
        <div class="card-header">
            <div class="card-title">
                <div ng-controller="taskCtrl">
                    <div class="planning-dropdown float-left" uib-dropdown on-toggle="scrollToActiveSprint(open)">
                        <div class="active">
                            <a href="{{ openSprintUrl(sprint) }}" class="link"><i class="fa fa-tasks"></i> {{ (sprint | sprintName) + ' - ' + (sprint.state | i18n: 'SprintStates') }}</a>
                            <i ng-if="sprintEntries.length > 2" uib-dropdown-toggle></i>
                            <span class="sub-title text-muted" uib-dropdown-toggle>
                                <span title="{{ sprint.startDate | dayShort }}">{{ sprint.startDate | dayShorter }}</span> <i class="fa fa-angle-right"></i>
                                <span title="{{ sprint.endDate | dayShort }}">{{ sprint.endDate | dayShorter }}</span>
                                <span class="sprint-numbers">
                                    <span ng-if="sprint.state > sprintStatesByName.TODO"
                                          defer-tooltip="${message(code: 'is.sprint.velocity')}">{{ sprint.velocity | roundNumber:2 }} /</span>
                                    <span defer-tooltip="${message(code: 'is.sprint.plannedVelocity')}">{{ sprint.capacity | roundNumber:2 }}</span>
                                    <i class="small-icon fa fa-dollar"></i>
                                </span>
                                <span class="sprint-remaining" defer-tooltip="${message(code: 'is.task.estimation')}">
                                    {{ totalRemainingTime(sprint.tasks | filter: currentSprintFilter.filter) | roundNumber:2 }} <i class="small-icon fa fa-hourglass-half"></i>
                                </span>
                            </span>
                        </div>
                        <ul uib-dropdown-menu role="menu" class="planning-menu">
                            <li ng-repeat="sprintEntry in sprintEntries | orderBy: 'orderNumber'"
                                ng-switch="sprintEntry.type"
                                ng-class="{'divider': 'dropdown-divider', 'release': 'dropdown-header'}[sprintEntry.type]">
                                <a ng-switch-when="sprint"
                                   ng-class="{'active': sprintEntry.item.id == sprint.id}"
                                   href="{{ openSprintUrl(sprintEntry.item, true) }}">
                                    <i class="fa fa-tasks"></i> {{ (sprintEntry.item | sprintName) + ' - ' + (sprintEntry.item.state | i18n: 'SprintStates') }}
                                    <div class="sub-title text-muted">
                                        {{ sprintEntry.item.startDate | dayShorter }} <i class="fa fa-angle-right"></i> {{ sprintEntry.item.endDate | dayShorter }}
                                    </div>
                                </a>
                                <span ng-switch-when="release">
                                    {{ sprintEntry.item.name }}
                                </span>
                            </li>
                        </ul>
                    </div>
                    <div class="btn-toolbar float-right">
                        <g:set var="formats" value="${is.exportFormats(windowDefinition: 'taskBoard', entryPoint: 'sprintDetails')}"/>
                        <g:if test="${formats}">
                            <div class="btn-group hidden-xs" uib-dropdown ng-if="authenticated()">
                                <button class="btn btn-secondary"
                                        uib-dropdown-toggle type="button">
                                    <span defer-tooltip="${message(code: 'todo.is.ui.export')}"><i class="fa fa-download"></i></span>
                                </button>
                                <ul uib-dropdown-menu
                                    class="float-right"
                                    role="menu">
                                    <g:each in="${formats}" var="format">
                                        <li role="menuitem">
                                            <a href="${format.onlyJsClick ? '' : (format.resource ?: 'story') + '/sprint/{{ ::sprint.id }}/' + (format.action ?: 'print') + '/' + (format.params.format ?: '')}"
                                               ng-click="${format.jsClick ? format.jsClick : 'print'}($event)">${format.name}</a>
                                        </li>
                                    </g:each>
                                </ul>
                            </div>
                        </g:if>
                        <div class="btn-group">
                            <button type="button"
                                    class="btn btn-secondary hidden-xs hidden-sm"
                                    defer-tooltip="${message(code: 'todo.is.ui.stickynote.size')}"
                                    ng-click="setStickyNoteSize(viewName)"><i class="fa" ng-class="iconCurrentStickyNoteSize(viewName)"></i>
                            </button>
                            <button type="button"
                                    class="btn btn-secondary hidden-xs"
                                    defer-tooltip="${message(code: 'is.ui.window.fullscreen')}"
                                    ng-click="fullScreen()"><i class="fa fa-arrows-alt"></i>
                            </button>
                        </div>
                        <div class="btn-group" uib-dropdown>
                            <button class="btn btn-secondary"
                                    uib-dropdown-toggle
                                    type="button">
                                <span defer-tooltip="${message(code: 'todo.is.ui.filters')}">
                                    <span>{{ currentSprintFilter.name + ' (' + currentSprintFilter.count + ')'}}</span>
                                </span>
                            </button>
                            <ul uib-dropdown-menu role="menu">
                                <li role="menuitem"
                                    ng-repeat="sprintFilter in sprintFilters"
                                    ng-class="{'dropdown-header': sprintFilter.id == 'header', 'dropdown-divider': sprintFilter.id == 'divider'}">
                                    <a ng-if="sprintFilter.id != 'header' && sprintFilter.id != 'divider'"
                                       ng-click="changeSprintFilter(sprintFilter)"
                                       href>
                                        {{ sprintFilter.name + ' (' + (sprintFilter.count | orElse: 0) + ')'}}
                                    </a>
                                    <span ng-if="sprintFilter.id == 'header'">{{ ::sprintFilter.name }}</span>
                                </li>
                            </ul>
                        </div>
                        <entry:point id="taskBoard-window-toolbar-right"/>
                        <div class="btn-group" role="group" ng-controller="sprintCtrl">
                            <shortcut-menu ng-model="sprint" model-menus="menus" view-type="viewName"></shortcut-menu>
                            <div class="btn-group" uib-dropdown>
                                <button type="button" class="btn btn-secondary" uib-dropdown-toggle>
                                </button>
                                <div uib-dropdown-menu class="float-right" ng-init="itemType = 'sprint'" template-url="item.menu.html"></div>
                            </div>
                        </div>
                        <a class="btn btn-secondary" href="{{ openSprintUrl(sprint) }}">
                            <i class="fa fa-pencil"
                               defer-tooltip="${message(code: 'todo.is.ui.details')}"></i>
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="card-body" id="tasks-board" ng-controller="taskCtrl">
            <div class="window-alert bg-warning"
                 ng-if="currentSprintFilter.id != 'allTasks'"
                 style="margin: 0 10px;">
                ${message(code: 'todo.is.ui.filter.current')}
                {{ currentSprintFilter.name }}
                (<strong><a href class="link" ng-click="changeSprintFilter(getDefaultFilter())">${message(code: 'todo.is.ui.disable')}</a></strong>)
            </div>
            <div selectable="selectableOptions" sticky-list="#tasks-board">
                <div>
                    <div ng-if="sprint.state != sprintStatesByName.DONE">
                        ${message(code: 'is.task.state.wait')} ({{ taskCountByState[taskStatesByName.TODO] | orElse:0 }})
                    </div>
                    <div ng-if="sprint.state == sprintStatesByName.IN_PROGRESS">
                        ${message(code: 'is.task.state.inprogress')} ({{ taskCountByState[taskStatesByName.IN_PROGRESS] | orElse:0 }})
                    </div>
                    <div ng-if="sprint.state != sprintStatesByName.TODO">
                        ${message(code: 'is.task.state.done')} ({{ taskCountByState[taskStatesByName.DONE] | orElse:0 }})
                    </div>
                </div>
                <div class="swimlane"
                     ng-if="authorizedTask('showUrgent')">
                    <span>${message(code: 'is.ui.sprintPlan.kanban.urgentTasks')} ({{ taskCountByType[taskTypesByName.URGENT] | orElse:0 }})</span>
                    <div>
                        <div class="sticky-notes {{ stickyNoteClass }}"
                             ng-class="{'show-tasks':!tasksShown(taskState, taskTypesByName.URGENT), 'has-selected' : hasSelected()}"
                             ng-model="tasksByTypeByStateAndSearchFiltered[taskTypesByName.URGENT][taskState]"
                             ng-init="taskType = taskTypesByName.URGENT"
                             as-sortable="taskSortableOptions | merge: sortableScrollOptions()"
                             is-disabled="!isSortableTaskBoard(sprint)"
                             ng-repeat="taskState in sprintTaskStates">
                            <div is-watch="task"
                                 ng-repeat="task in tasksByTypeByStateAndSearchFiltered[taskTypesByName.URGENT][taskState]"
                                 ng-if="tasksShown(taskState, taskTypesByName.URGENT)"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="sticky-note-container sticky-note-task">
                                <div ng-include="'task.html'"></div>
                            </div>
                            <button type="button"
                                    ng-if="!tasksShown(taskState, taskTypesByName.URGENT)"
                                    class="btn btn-secondary"
                                    ng-click="showTasks(taskTypesByName.URGENT, true)">
                                {{ message('todo.is.ui.task.showDoneTasks', [tasksByTypeByState[taskTypesByName.URGENT][taskState].length]) }}
                            </button>
                            <div ng-if="tasksHidden(taskState, taskTypesByName.URGENT)" class="sticky-note-container sticky-note-task">
                                <div class="hide-tasks sticky-note">
                                    <button type="button"
                                            class="btn btn-secondary"
                                            ng-click="showTasks(taskTypesByName.URGENT, false)">
                                        {{ message('todo.is.ui.task.hideDoneTasks', [tasksByTypeByState[taskTypesByName.URGENT][taskState].length]) }}
                                    </button>
                                </div>
                            </div>
                            <div ng-if="taskState == taskStatesByName.TODO && authorizedTask('create', {sprint: sprint})" class="sticky-note-container sticky-note-task">
                                <div class="add-task sticky-note">
                                    <a ng-click="openNewTaskByType(taskTypesByName.URGENT)" href>+</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="swimlane"
                     ng-if="authorizedTask('showRecurrent')">
                    <span>${message(code: 'is.ui.sprintPlan.kanban.recurrentTasks')} ({{ taskCountByType[taskTypesByName.RECURRENT] | orElse:0 }})</span>
                    <div>
                        <div class="sticky-notes {{ stickyNoteClass }}"
                             ng-class="{'show-tasks':!tasksShown(taskState, taskTypesByName.RECURRENT), 'has-selected' : hasSelected()}"
                             ng-model="tasksByTypeByStateAndSearchFiltered[taskTypesByName.RECURRENT][taskState]"
                             ng-init="taskType = taskTypesByName.RECURRENT"
                             as-sortable="taskSortableOptions | merge: sortableScrollOptions()"
                             is-disabled="!isSortableTaskBoard(sprint)"
                             ng-repeat="taskState in sprintTaskStates">
                            <div is-watch="task"
                                 ng-repeat="task in tasksByTypeByStateAndSearchFiltered[taskTypesByName.RECURRENT][taskState]"
                                 ng-if="tasksShown(taskState, taskTypesByName.RECURRENT)"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="sticky-note-container sticky-note-task">
                                <div ng-include="'task.html'"></div>
                            </div>
                            <button type="button"
                                    ng-if="!tasksShown(taskState, taskTypesByName.RECURRENT)"
                                    class="btn btn-secondary"
                                    ng-click="showTasks(taskTypesByName.RECURRENT, true)">
                                {{ message('todo.is.ui.task.showDoneTasks', [tasksByTypeByState[taskTypesByName.RECURRENT][taskState].length]) }}
                            </button>
                            <div ng-if="tasksHidden(taskState, taskTypesByName.RECURRENT)" class="sticky-note-container sticky-note-task">
                                <div class="hide-tasks sticky-note">
                                    <button type="button"
                                            class="btn btn-secondary"
                                            ng-click="showTasks(taskTypesByName.RECURRENT, false)">
                                        {{ message('todo.is.ui.task.hideDoneTasks', [tasksByTypeByState[taskTypesByName.RECURRENT][taskState].length]) }}
                                    </button>
                                </div>
                            </div>
                            <div ng-if="taskState == taskStatesByName.TODO && authorizedTask('create', {sprint: sprint})" class="sticky-note-container sticky-note-task">
                                <div class="add-task sticky-note">
                                    <a ng-click="openNewTaskByType(taskTypesByName.RECURRENT)" href>+</a>
                                    <a ng-click="copyRecurrentTasks(sprint)" href>${message(code: 'is.ui.sprintPlan.kanban.copyRecurrentTasks')}</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div ng-repeat="story in sprint.stories | filter: storyFilter | taskBoardSearch: tasksByStoryByState | orderBy: 'rank'" ng-class="{'story-done': story.state == storyStatesByName.DONE }">
                    <div class="list-group">
                        <div class="sticky-note-container sticky-note-story"
                             ng-controller="storyCtrl"
                             ng-click="selectStory($event, story.id)"
                             is-watch="story"
                             ng-class="{'is-selected': isSelected(story)}">
                            <div ng-include="'story.html'" ng-init="disabledGradient = true"></div>
                        </div>
                    </div>
                    <div ng-class="{'is-selected': isSelected(story)}">
                        <div class="sticky-notes {{ stickyNoteClass }}"
                             ng-class="{'show-tasks':!tasksShown(taskState, story), 'has-selected' : hasSelected()}"
                             ng-model="tasksByStoryByState[story.id][taskState]"
                             as-sortable="taskSortableOptions | merge: sortableScrollOptions()"
                             is-disabled="!isSortableTaskBoard(sprint) || !isSortableStory(story)"
                             ng-repeat="taskState in sprintTaskStates">
                            <div is-watch="task"
                                 ng-repeat="task in tasksByStoryByState[story.id][taskState]"
                                 ng-if="tasksShown(taskState, story)"
                                 ng-class="{ 'is-selected': isSelected(task) }"
                                 selectable-id="{{ ::task.id }}"
                                 as-sortable-item
                                 class="sticky-note-container sticky-note-task">
                                <div ng-include="'task.html'"></div>
                            </div>
                            <button type="button"
                                    ng-if="!tasksShown(taskState, story)"
                                    class="btn btn-secondary"
                                    ng-click="showTasks(story, true)">{{ message('todo.is.ui.task.showDoneTasks', [tasksByStoryByState[story.id][taskState].length]) }}
                            </button>
                            <div ng-if="tasksHidden(taskState, story)" class="sticky-note-container sticky-note-task">
                                <div class="hide-tasks sticky-note">
                                    <button type="button"
                                            class="btn btn-secondary"
                                            ng-click="showTasks(story, false)">
                                        {{ message('todo.is.ui.task.hideDoneTasks', [tasksByStoryByState[story.id][taskState].length]) }}
                                    </button>
                                </div>
                            </div>
                            <div ng-if="taskState == taskStatesByName.TODO && authorizedTask('create', {parentStory: story})" class="sticky-note-container sticky-note-task">
                                <div class="add-task sticky-note">
                                    <a ng-click="openNewTaskByStory(story)" href>+</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div ng-repeat="story in ghostStories | filter: storyFilter | taskBoardSearch: tasksByStoryByState | orderBy: 'id'" class="story-ghost">
                    <div class="list-group">
                        <div class="sticky-note-container sticky-note-story" ng-controller="storyCtrl" ng-click="selectStory($event, story.id)" ng-class="{'is-selected': isSelected(story)}">
                            <div ng-include="'story.light.html'" ng-init="disabledGradient = true"></div>
                        </div>
                    </div>
                    <div class="sticky-notes {{ stickyNoteClass }}"
                         ng-class="{'show-tasks':!tasksShown(taskState, story, true), 'has-selected' : hasSelected()}"
                         ng-model="tasksByStoryByState[story.id][taskState]"
                         as-sortable
                         is-disabled="true"
                         ng-repeat="taskState in sprintTaskStates">
                        <div is-watch="task"
                             ng-repeat="task in tasksByStoryByState[story.id][taskState]"
                             ng-if="tasksShown(taskState, story, true)"
                             ng-class="{ 'is-selected': isSelected(task) }"
                             selectable-id="{{ ::task.id }}"
                             as-sortable-item
                             class="sticky-note-container sticky-note-task">
                            <div ng-include="'task.html'"></div>
                        </div>
                        <button type="button"
                                ng-if="!tasksShown(taskState, story, true)"
                                class="btn btn-secondary"
                                ng-click="showTasks(story, true)">{{ message('todo.is.ui.task.showDoneTasks', [tasksByStoryByState[story.id][taskState].length]) }}
                        </button>
                        <div ng-if="tasksHidden(taskState, story, true)" class="sticky-note-container sticky-note-task">
                            <div class="hide-tasks sticky-note">
                                <button type="button"
                                        class="btn btn-secondary"
                                        ng-click="showTasks(story, false)">
                                    {{ message('todo.is.ui.task.hideDoneTasks', [tasksByStoryByState[story.id][taskState].length]) }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <div ng-if="sprint.stories.length == 0 && sprint.state < sprintStatesByName.DONE">
                    <div class="empty-view">
                        <p class="form-text">${message(code: 'todo.is.ui.story.empty.taskBoard')}</p>
                        <a class="btn btn-secondary"
                           href="#/planning/{{ sprint.parentRelease.id }}/sprint/{{ sprint.id }}">
                            <i class="fa fa-inbox"></i> ${message(code: 'todo.is.ui.planning')}
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div ng-if="!sprint"
         class="card">
        <div class="card-body">
            <div class="empty-view">
                <p class="form-text">${message(code: 'todo.is.ui.taskBoard.empty')}<p>
                <a class="btn btn-primary"
                   href="#planning">
                    <i class="fa fa-calendar"></i> ${message(code: 'todo.is.ui.planning')}
                </a>
            </div>
        </div>
    </div>
</is:window>