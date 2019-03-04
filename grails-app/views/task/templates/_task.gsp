%{--
- Copyright (c) 2015 Kagilum.
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

<script type="text/ng-template" id="task.html">
<div sticky-note-color="{{:: task.color }}"
     class="sticky-note"
     ng-class=":: ['task', application.stickyNoteSize.task, (task.color | contrastColor), { 'task-blocked': task.blocked }]">
    <div as-sortable-item-handle="authorizedTask('rank', task)">
        <div class="head">
            <img ng-src="{{:: task.responsible | userAvatar }}"
                 ng-if=":: task.responsible"
                 ng-class="::['responsible', (task.responsible | userColorRoles)]"
                 defer-tooltip="{{:: task.responsible | userFullName }}">
            <span class="id">{{:: task.uid }}</span>
        </div>
        <div class="content">
            <div class="item-values">
                <span class="remaining-time editable"
                      ng-if=":: task.estimation != 0"
                      ng-click="showEditEstimationModal(task, $event)">
                    ${message(code: 'is.task.estimation')} {{:: task.estimation != undefined ? task.estimation : '?' }}
                </span>
            </div>
            <div class="title">{{:: task.name }}</div>
            <div class="description" ng-bind-html=":: task.description | lineReturns"></div>
        </div>
        <div class="footer">
            <div class="tags">
                <icon-badge class="float-right" tooltip="${message(code: 'is.backlogelement.tags')}"
                            href="#/{{:: viewName }}/{{:: sprint.id }}/task/{{:: task.id }}"
                            icon="fa-tags"
                            max="3"
                            hide="true"
                            count="{{:: task.tags.length }}"/>
                <a ng-repeat="tag in ::task.tags"
                   href="{{:: tagContextUrl(tag) }}">
                    <span class="tag {{ getTagColor(tag, 'task') | contrastColor }}"
                          ng-style="{'background-color': getTagColor(tag, 'story') }">{{:: tag }}</span>
                </a>
            </div>
            <div class="actions">
                <icon-badge tooltip="${message(code: 'todo.is.ui.backlogelement.attachments')}"
                            href="#/{{:: viewName }}/{{:: sprint.id }}/task/{{:: task.id }}"
                            icon="fa-paperclip"
                            count="{{:: task.attachments_count }}"/>
                <icon-badge classes="comments"
                            tooltip="${message(code: 'todo.is.ui.comments')}"
                            href="#/{{:: viewName }}/{{:: sprint.id }}/task/{{:: task.id }}/comments"
                            icon="fa-comment"
                            icon-empty="fa-comment-o"
                            count="{{:: task.comments_count }}"/>
                <span class="action" ng-if="::authorizedTask('take', task)">
                    <a href
                       ng-click="take(task)"
                       defer-tooltip="${message(code: 'is.ui.sprintPlan.menu.task.take')}">
                        <i class="fa fa-user-plus"></i>
                    </a>
                </span>
                <span class="action" ng-if="::authorizedTask('release', task)">
                    <a href
                       ng-click="release(task)"
                       defer-tooltip="${message(code: 'is.ui.sprintPlan.menu.task.unassign')}">
                        <i class="fa fa-user-times"></i>
                    </a>
                </span>
                <span sticky-note-menu="item.menu.html" ng-init="itemType = 'task'" class="action"><a><i class="fa fa-ellipsis-h"></i></a></span>
            </div>
            <entry:point id="task-sticky-note-bottom"/>
        </div>
    </div>
</div>
</script>