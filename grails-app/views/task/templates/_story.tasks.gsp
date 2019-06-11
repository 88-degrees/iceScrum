%{--
- Copyright (c) 2014 Kagilum.
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
--}%
<script type="text/ng-template" id="story.tasks.html">
<div class="tasks panel-body" ng-controller="taskSortableStoryCtrl">
    <table class="table" ng-repeat="taskEntry in tasksByState">
        <thead>
            <tr>
                <th style="border-top: 0; border-bottom: 0; padding:0">
                    <div class="text-center" style="margin-bottom:10px;font-size:15px;"
                         ng-style="::{ 'margin-top': (taskEntry.state != 0) ? '30px' : '0' }"
                         ng-bind-html="taskEntry.label">
                    </div>
                </th>
            </tr>
        </thead>
        <tbody style="border-top: 0;"
               is-disabled="!isTaskSortableByState(taskEntry.state)"
               as-sortable="taskSortableOptions | merge: sortableScrollOptions()"
               ng-model="taskEntry.tasks">
            <tr class="task-for-story" ng-repeat="task in taskEntry.tasks" as-sortable-item>
                <td class="content">
                    <div class="clearfix no-padding">
                        <div class="col-sm-8">
                            <span class="name">
                                <i class="fa fa-drag-handle" ng-if="isTaskSortableByState(taskEntry.state)" as-sortable-item-handle></i>
                                <a ui-sref=".task.details({taskId: task.id})" class="link">
                                    <strong>{{:: task.uid }}</strong>&nbsp;&nbsp;{{ task.name }}
                                </a>
                            </span>
                        </div>
                        <div class="col-sm-4 text-right" ng-controller="taskCtrl">
                            <div class="btn-group">
                                <shortcut-menu ng-model="task" model-menus="menus" view-type="'list'" btn-sm="true"></shortcut-menu>
                                <div class="btn-group btn-group-sm" uib-dropdown>
                                    <button type="button" class="btn btn-default" uib-dropdown-toggle>
                                        <i class="fa fa-caret-down"></i>
                                    </button>
                                    <ul uib-dropdown-menu class="pull-right" ng-init="itemType = 'task'" template-url="item.menu.html"></ul>
                                </div>
                                <visual-states ng-model="task" model-states="taskStatesByName"/>
                            </div>
                        </div>
                    </div>
                    <div class="clearfix no-padding" ng-if="task.description" style="margin-top: 5px">
                        <p class="description form-control-static" ng-bind-html="task.description | lineReturns"></p>
                    </div>
                    <hr ng-if="!$last"/>
                </td>
            </tr>
        </tbody>
    </table>
    <div class="help-block text-center"
         ng-if="selected.tasks !== undefined && !selected.tasks.length">
        ${message(code: 'is.ui.task.help.story')}
        <documentation doc-url="features-stories-tasks#tasks"/>
    </div>
</div>
<div class="panel-footer" ng-controller="taskStoryCtrl">
    <div ng-if="authorizedTask('create', {parentStory: selected})" ng-include="'story.task.new.html'"></div>
</div>
</script>