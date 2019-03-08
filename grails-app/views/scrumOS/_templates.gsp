%{--
- Copyright (c) 2014 Kagilum SAS.
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
<div id="templates">
    <script type="text/ng-template" id="loading.html">
    <svg class="logo" viewBox="0 0 150 150">
        <g:render template="/scrumOS/logo"/>
    </svg>
    </script>

    <script type="text/ng-template" id="chart.modal.html">
    <is:modal title="${message(code: 'is.ui.widget.chart.chart')}">
        <nvd3 options="options" data="data" config="{refreshDataOnly: false}"></nvd3>
    </is:modal>
    </script>

    <script type="text/ng-template" id="confirm.modal.html">
    <is:modal form="submit()"
              submitButton="{{ buttonTitle }}"
              submitButtonColor="{{ buttonColor }}"
              closeButton="${message(code: 'is.button.cancel')}"
              title="${message(code: 'todo.is.ui.confirm.title')}">
        <span ng-bind-html="message"></span>
    </is:modal>
    </script>

    <script type="text/ng-template" id="message.modal.html">
    <is:modal title="{{:: title }}">
        <span ng-bind-html="message"></span>
    </is:modal>
    </script>

    <script type="text/ng-template" id="confirm.dirty.modal.html">
    <is:modal form="saveChanges()"
              button="[[text: message(code: 'todo.is.ui.dirty.confirm.dontsave'), color: 'danger', action: 'dontSave()']]"
              submitButton="${message(code: 'todo.is.ui.dirty.confirm.save')}"
              closeButton="${message(code: 'is.button.cancel')}"
              title="${message(code: 'todo.is.ui.dirty.confirm.title')}">
        {{ message }}
    </is:modal>
    </script>

    <script type="text/ng-template" id="confirm.portfolio.cancel.modal.html">
    <is:modal form="confirmDelete()"
              submitButtonColor="danger"
              submitButton="${message(code: 'is.ui.portfolio.confirm.cancel.confirm')}"
              closeButton="${message(code: 'is.ui.portfolio.confirm.cancel.back')}"
              title="${message(code: 'todo.is.ui.confirm.title')}">
        <div class="alert alert-warning" role="alert" style="margin-bottom: 15px;">
            <i class="fa fa-warning"></i> ${message(code: 'is.ui.portfolio.confirm.cancel.description')}
        </div>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>${message(code: 'is.project.name')}</th>
                    <th style="width:20px"><i class="fa fa-trash"></i></th>
                </tr>
            </thead>
            <tbody>
                <tr ng-repeat="project in deletableProjects">
                    <td>{{:: project.name }}</td>
                    <td><input type="checkbox" ng-model="project.delete"/></td>
                </tr>
            </tbody>
        </table>
    </is:modal>
    </script>

    <script type="text/ng-template" id="select.or.create.team.html">
    <a>
        <span ng-show="!match.model.id">${message(code: 'todo.is.ui.create.team')}</span> <strong>{{ match.model.name }}</strong>
    </a>
    </script>

    <script type="text/ng-template" id="select.or.create.project.html">
    <a ng-class="{'disabled': match.model.portfolio}">
        <span ng-show="!match.model.id">${message(code: 'todo.is.ui.project.create')}</span> <strong>{{ match.model.name }}</strong> <span ng-if="match.model.portfolio">(${message(code: 'is.project.already.in.portfolio')})</span>
    </a>
    </script>

    <script type="text/ng-template" id="button.shortcutMenu.html">
    <a ng-show="menuElement.name"
       class="btn"
       title="{{ menuElement | menuElementName }}"
       ng-class="{'btn-sm': btnSm, 'btn-intermediate': !btnSm, 'btn-primary': !btnSecondary, 'btn-secondary': btnSecondary}"
       ng-href="{{ menuElement.url(ngModel) }}"
       ng-click="menuElement.action(ngModel)">
        {{ menuElement | menuElementName }}
    </a>
    </script>

    <script type="text/ng-template" id="item.menu.html">
    <div ng-controller="menuItemCtrl" class="dropdown-menu dropdown-menu-right" uib-dropdown-menu role="menu">
        <a class="dropdown-item"
           ng-repeat="menuElement in menus | visibleMenuElement: getItem()"
           ng-href="{{ menuElement.url(getItem()) }}"
           ng-click="menuElement.action(getItem())">
            {{:: menuElement | menuElementName }}
        </a>
    </div>
    </script>

    <script type="text/ng-template" id="select.member.html">
    <a>
        <span style="margin-top: 5px;margin-left:5px;">{{ match.model | userFullName }}</span>
        <button class="btn btn-secondary btn-sm" type="button" ng-show="!match.model.id">
            ${message(code: 'is.ui.user.will.be.invited.click')} <i class="fa fa-envelope"></i>
        </button>
    </a>
    </script>

    <script type="text/ng-template" id="report.progress.html">
    <is:modal title="${message(code: 'is.dialog.report.generation')}">
        <p class="form-text">
            <g:message code="is.dialog.report.description"/>
        </p>
        <is-progress start="progress"></is-progress>
    </is:modal>
    </script>

    <script type="text/ng-template" id="is.progress.html">
    <uib-progressbar value="progress.value" type="{{ progress.type }}">
        <b>{{progress.label}}</b>
    </uib-progressbar>
    </script>

    <script type="text/ng-template" id="menuitem.item.html">
    <a hotkey="{ '{{:: menu.shortcut }}' : hotkeyClick }"
       class="nav-link"
       hotkey-description="${message(code: 'todo.is.ui.open.view')} {{ menu.title }}"
       href="{{ getMenuUrl(menu) }}">
        <span class="nav-link-icon" ng-class="'nav-link-icon-' + menu.id" as-sortable-item-handle></span>
        <span defer-tooltip="{{:: menu.title + ' (' + menu.shortcut + ')' }}" tooltip-placement="bottom" class="nav-link-title">{{:: menu.title }}</span>
    </a>
    </script>

    <script type="text/ng-template" id="profile.panel.html">
    <div class="media">
        <div class="media-left">
            <img ng-src="{{ currentUser | userAvatar }}"
                 alt="{{currentUser | userFullName}}"
                 height="50px"
                 width="50px"/>
        </div>
        <div class="media-body">
            <div>
                {{ (currentUser | userFullName) + ' (' + currentUser.username + ')' }}
            </div>
            <div class="text-muted">
                <div>{{currentUser.email}}</div>
                <div>{{currentUser.preferences.activity}}</div>
                <div>
                    <strong>{{:: getCurrentUserRoles() }}</strong>
                </div>
                <entry:point id="user-profile-panel"/>
            </div>
        </div>
    </div>
    <div class="btn-toolbar float-right">
        <a href
           class="btn btn-secondary"
           hotkey="{'shift+u':showProfile}"
           hotkey-description="${message(code: 'todo.is.ui.profile')}"
           defer-tooltip="${message(code: 'is.dialog.profile')} (shift+u)"
           ng-click="showProfile()">${message(code: 'is.dialog.profile')}
        </a>
        <a class="btn btn-danger"
           href="${createLink(controller: 'logout')}">
            ${message(code: 'is.logout')}
        </a>
    </div>
    </script>

    <script type="text/ng-template" id="notifications.panel.html">
    <div class="empty-content" ng-show="groupedUserActivities === undefined">
        <i class="fa fa-refresh fa-spin"></i>
    </div>
    <div ng-repeat="groupedActivity in groupedUserActivities">
        <div><h4><a href="{{ serverUrl + '/p/' + groupedActivity.project.pkey + '/' }}">{{ groupedActivity.project.name }}</a></h4></div>
        <div class="media" ng-class="{ 'unread': activity.notRead }" ng-repeat="activity in groupedActivity.activities">
            <div class="media-left">
                <img height="36px"
                     ng-src="{{activity.poster | userAvatar}}"
                     class="{{ activity.poster | userColorRoles }}"
                     alt="{{activity.poster | userFullName}}"/>
            </div>
            <div class="media-body">
                <div class="text-muted float-right">
                    <time timeago datetime="{{ activity.dateCreated }}">
                        {{ activity.dateCreated | dateTime }}
                    </time>
                    <i class="fa fa-clock-o"></i>
                </div>
                <div>
                    {{activity.poster | userFullName}}
                </div>
                <div>
                    <span>{{ activity | activityName }} <a href="{{ activity.story.uid | permalink: 'story': groupedActivity.project.pkey }}">{{ activity.story.name }}</a></span>
                </div>
            </div>
        </div>
    </div>
    <div class="empty-content" ng-show="groupedUserActivities != undefined && groupedUserActivities.length == 0">
        <small>${message(code: 'todo.is.ui.history.empty')}</small>
    </div>
    </script>

    <script type="text/ng-template" id="search.context.html">
    <a class="text-ellipsis">
        <i class="fa" ng-class="match.model.type | contextIcon" style="color: {{ match.model.color }}"></i> {{ match.model.term }}
    </a>
    </script>

    <script type="text/ng-template" id="details.modal.html">
    <is:modal footer="${false}" title="{{ message('is.' + detailsType) }}" class="modal-details">
        <div ui-view="details"></div>
    </is:modal>
    </script>

    <script type="text/ng-template" id="states.html">
    <div class="states progress">
        <div ng-repeat="state in states" class="progress-bar state {{ state.class }}"
             ng-class="{'state-completed': state.completed, 'state-current': state.current}"
             ng-style="{width: state.width + '%'}">
            <span class="state-name" tooltip-placement="left" defer-tooltip="{{ state.tooltip  }}">{{ state.name }}</span>
        </div>
    </div>
    </script>

    <script type="text/ng-template" id="details.layout.buttons.html">
    <div class="btn-group">
        <button class="btn btn-secondary minimizable"
                ng-click="toggleMinimizedDetailsView()"
                defer-tooltip="${message(code: 'is.ui.window.minimize')}">
            <i ng-class="['fa fa-window-minimize', application.minimizedDetailsView ? 'fa-rotate-180' : '']"></i>
        </button>
        <button class="btn btn-secondary detachable"
                ng-click="toggleDetachedDetailsView()"
                defer-tooltip="${message(code: 'is.ui.window.detach')}">
            <i ng-class="['fa', application.detachedDetailsView ? 'fa-window-maximize' : 'fa-window-restore']"></i>
        </button>
        <a class="btn btn-secondary"
           href="{{ closeDetailsViewUrl() }}"
           defer-tooltip="${message(code: 'is.ui.window.closeable')}">
            <i class="fa fa-times"></i>
        </a>
    </div>
    </script>

    <script type="text/ng-template" id="icon.with.badge.html">
    <span class="action {{:: classes }}">
        <a href="{{:: href }}"
           class="action-link"
           defer-tooltip="{{:: tooltip }}">
            <span class="action-icon action-icon-{{:: icon }}"></span>
            <span class="badge"><span class="limited">{{:: countString }}</span><span class="full">{{:: count }}</span></span>
        </a>
    </span>
    </script>

    <script type="text/ng-template" id="addWidget.modal.html">
    <is:modal title="${message(code: 'is.ui.widget.new')}"
              validate="true"
              name="addWidgetForm"
              form="addWidget(widgetDefinition)"
              submitButton="${message(code: 'is.ui.widget.add')}"
              class="split-modal">
        <div class="row">
            <div class="left-card col-sm-3">
                <div class="left-card-header">
                    <div class="input-group">
                        <input type="text"
                               ng-model="widgetDefinitionSearch"
                               name="widget-definition-search-input"
                               class="form-control"
                               placeholder="${message(code: 'todo.is.ui.search.action')}">
                        <span class="input-group-append">
                            <button class="btn btn-secondary btn-sm"
                                    type="button"
                                    ng-click="widgetDefinitionSearch = ''">
                                <i class="fa" ng-class="widgetDefinitionSearch ? 'fa-times' : 'fa-search'"></i>
                            </button>
                        </span>
                    </div>
                </div>
                <ul class="left-card-body nav nav-list">
                    <li ng-class="{ 'current': currentWidgetDefinition.id == widgetDefinition.id }"
                        ng-repeat="currentWidgetDefinition in widgetDefinitions | filter:widgetDefinitionSearch">
                        <a ng-click="detailsWidgetDefinition(currentWidgetDefinition)" href>
                            <i class="fa fa-{{ currentWidgetDefinition.icon }}"></i> {{ currentWidgetDefinition.name }}
                        </a>
                    </li>
                </ul>
            </div>
            <div class="right-card col-sm-9" ng-switch="widgetDefinitions != undefined && widgetDefinitions.length == 0">
                <div ng-switch-when="true">
                    ${message(code: 'is.ui.widget.noAvailableWidgetDefinitions')}
                </div>
                <div class="col-md-12" ng-switch-default>
                    <div ng-include="'widgetDefinition.details.html'"></div>
                </div>
            </div>
        </div>
    </is:modal>
    </script>

    <script type="text/ng-template" id="project.digest.html">
    <h4 class="col-md-12 clearfix">
        <div class="float-left"><a href="{{:: project.pkey | projectUrl }}" class="link">{{:: project.name }}</a> <small>owned by {{:: project.owner | userFullName }}</small></div>
        <div class="float-right">
            <small><time timeago datetime="{{:: project.lastUpdated }}">{{ project.lastUpdated | dateTime }}</time> <i class="fa fa-clock-o"></i></small>
        </div>
    </h4>
    <div class="col-lg-9 col-xs-9">
        <div class="description" ng-bind-html="project.description_html | truncateAndSeeMore:project.pkey:(widget.settings.width == 2 ? 195 : null)"></div>
        <div ng-if="project.currentOrNextRelease.currentOrNextSprint.goal" style="margin-top:8px;">
            <p><strong>{{:: message('todo.is.ui.sprint.goal.label', [project.currentOrNextRelease.currentOrNextSprint.index]) }}</strong>
                <span ng-bind-html="project.currentOrNextRelease.currentOrNextSprint.goal | truncateAndSeeMore:project.pkey:(widget.settings.width == 2 ? 20 : 80):'/#/taskBoard/'+project.currentOrNextRelease.currentOrNextSprint.id"></span>
            </p>
        </div>
    </div>
    <div class="col-lg-3 col-xs-3">
        <div class="backlogCharts chart float-right" ng-controller="chartCtrl" ng-init="openChart('backlog', 'state', (project | retrieveBacklog:'all'), backlogChartOptions)">
            <nvd3 options="options" ng-if="data.length > 0" data="data" config="{refreshDataOnly: false}"></nvd3>
        </div>
        <div class="team-name text-ellipsis" title="{{:: project.team.name }}"><i class="fa fa-users"></i> {{:: project.team.name }}</div>
    </div>
    <div class="col-lg-9 col-xs-9" style="margin-top:2px">
        <div class="row">
            <ul class="list-inline text-muted col-md-12">
                <li class="release" ng-if=":: project.currentOrNextRelease">
                    <a href="{{:: project.pkey | projectUrl }}#/planning/{{:: project.currentOrNextRelease.id }}" class="link"><i class="fa fa-calendar {{:: project.currentOrNextRelease.state | releaseStateColor }}"></i> <span
                            class="text-ellipsis">{{:: project.currentOrNextRelease.name }}</span></a>
                </li>
                <li class="features" ng-if=":: project.features_count">
                    <a href="{{:: project.pkey | projectUrl }}#/feature" class="link"><i class="fa fa-puzzle-piece"></i> {{:: project.features_count }} <g:message code="is.ui.feature"/></a>
                </li>
                <li class="stories" ng-if=":: project.stories_count">
                    <a href="{{:: project.pkey | projectUrl }}#/backlog" class="link"><i class="fa fa-sticky-note"></i> {{:: project.stories_count }} <g:message code="todo.is.ui.stories"/></a>
                </li>
                <li class="sprint" ng-if=":: project.currentOrNextRelease.currentOrNextSprint">
                    <a href="{{:: project.pkey | projectUrl }}#/taskBoard/{{:: project.currentOrNextRelease.currentOrNextSprint.id }}" class="link"><div
                            class="progress {{:: project.currentOrNextRelease.currentOrNextSprint.state | sprintStateColor:'background-light' }}">
                        <span class="progress-value">{{:: project.currentOrNextRelease.currentOrNextSprint | sprintName }}</span>
                        <div class="progress-bar {{:: project.currentOrNextRelease.currentOrNextSprint.state | sprintStateColor:'background' }}" role="progressbar"
                             aria-valuenow="{{:: project.currentOrNextRelease.currentOrNextSprint | computePercentage:'velocity':'capacity' }}" aria-valuemin="0" aria-valuemax="100"
                             style="width: {{:: project.currentOrNextRelease.currentOrNextSprint | computePercentage:'velocity':'capacity' }}%;"></div>
                    </div></a>
                    <small ng-if="project.currentOrNextRelease.currentOrNextSprint.state == 2"><i class="fa fa-clock-o"></i> <time timeago
                                                                                                                                   datetime="{{:: project.currentOrNextRelease.currentOrNextSprint.endDate }}">{{ project.currentOrNextRelease.currentOrNextSprint.endDate | dateTime }}</time>
                    </small>
                    <small ng-if="project.currentOrNextRelease.currentOrNextSprint.state == 1"><i class="fa fa-clock-o"></i> <time timeago
                                                                                                                                   datetime="{{:: project.currentOrNextRelease.currentOrNextSprint.startDate }}">{{ project.currentOrNextRelease.currentOrNextSprint.startDate | dateTime }}</time>
                    </small>
                </li>
            </ul>
        </div>
    </div>
    <div class="col-lg-3 col-xs-3 users" style="margin-top:2px">
        <img ng-src="{{:: user | userAvatar }}"
             ng-repeat="user in ::project.allUsers | limitTo:2"
             height="20" width="20" style="margin-left:5px;"
             class="{{:: user | userColorRoles:project }}"
             defer-tooltip="{{:: user | userFullName }}"/>
        <span class="team-count" ng-if=":: project.allUsers.length > 2">+ {{ project.allUsers.length - 2 }}</span>
    </div>
    </script>

    <script type="text/ng-template" id="widgetDefinition.details.html">
    <h4><i class="fa fa-{{ widgetDefinition.icon }}"></i> {{ widgetDefinition.name }}</h4>
    <p>{{ widgetDefinition.description }}</p>
    </script>

    <script type="text/ng-template" id="documentation.html">
    <a target="_blank"
       style="font-weight: bold"
       class="text-muted"
       ng-class="{small: !big}"
       href="https://www.icescrum.com/documentation/{{ docUrl }}?utm_source=tool&utm_medium=link&utm_campaign=icescrum">
        <i class="fa fa-question-circle"></i>
        <span ng-bind-html="message(title != null ? title : 'is.ui.documentation')"></span>
    </a>
    </script>

    <g:render template="/team/templates"/>
    <g:render template="/sprint/templates"/>
    <g:render template="/portfolio/templates"/>
    <g:render template="/project/templates"/>
    <g:render template="/release/templates"/>
    <g:render template="/task/templates/task.light"/>
    <g:render template="/user/templates"/>
    <g:render template="/task/templates/task.estimation"/>
    <g:render template="/feature/templates"/>
    <g:render template="/story/templates"/>
    <g:render template="/attachment/templates"/>
    <g:render template="/activity/templates"/>
    <g:render template="/comment/templates"/>
    <g:render template="/task/templates"/>
    <g:render template="/acceptanceTest/templates"/>
    <entry:point id="templates"/>
    <g:if test="${params.project}">
        <g:render template="/app/templates"/>
        <g:render template="/release/templates"/>
        <g:render template="/timeBoxNotesTemplate/templates"/>
        <g:render template="/backlog/templates"/>
        <entry:point id="templates-project"/>
    </g:if>
    <g:if test="${g.meta(name: 'app.displayWhatsNew')}">
        <script type="text/ng-template" id="is.dialog.whatsNew.html">
        <is:modal title="${message(code: 'is.dialog.about.whatsNew.title')}">
            <g:render template="/scrumOS/about/whatsNew"/>
        </is:modal>
        </script>
    </g:if>
</div>
