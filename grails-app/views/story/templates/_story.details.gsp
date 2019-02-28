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
<script type="text/ng-template" id="story.details.html">
<div class="card"
     flow-init
     flow-drop
     flow-files-submitted="attachmentQuery($flow, story)"
     flow-drop-enabled="authorizedStory('upload', story)"
     flow-drag-enter="dropClass='card drop-enabled'"
     flow-drag-leave="dropClass='card'"
     ng-class="authorizedStory('upload', story) && dropClass">
    <div class="card-header">
        <h3 class="card-title row">
            <div class="left-title">
                <i class="fa fa-sticky-note" ng-style="{color: story.feature ? story.feature.color : '#f9f157'}"></i>
                <strong>{{ ::story.uid }}</strong>
                <span defer-tooltip="{{ story.followers_ids.length }} ${message(code: 'todo.is.ui.followers')}"
                      ng-click="follow(story)">
                    <i class="fa" ng-class="story | followedByUser:'fa-star':'fa-star-o'"></i>
                </span>
                <span class="item-name" title="{{ story.name }}">{{ story.name }}</span>&nbsp;<small ng-show="story.origin">${message(code: 'is.story.origin')}: {{ story.origin }}</small>
                <div style="margin-top:10px">
                    <entry:point id="story-details-left-title"/>
                </div>
            </div>
            <div class="right-title">
                <div style="margin-bottom:10px" class="buttons-margin-bottom">
                    <entry:point id="story-details-right-title"/>
                    <span defer-tooltip="${message(code: 'is.story.creator')} {{ story.creator | userFullName }}">
                        <img ng-src="{{ story.creator | userAvatar }}" alt="{{ story.creator | userFullName }}" class="{{ story.creator | userColorRoles }}"
                             height="30px"/>
                    </span>
                    <a ng-if="previousStory()"
                       class="btn btn-secondary"
                       role="button"
                       tabindex="0"
                       hotkey="{'left': hotkeyClick}"
                       hotkey-description="${message(code: 'is.ui.backlogelement.toolbar.previous')}"
                       href="{{ currentStateUrl(previousStory().id) }}">
                        <i class="fa fa-caret-left" defer-tooltip="${message(code: 'is.ui.backlogelement.toolbar.previous')} (&#xf060;)"></i>
                    </a>
                    <a ng-if="nextStory()"
                       class="btn btn-secondary"
                       role="button"
                       tabindex="0"
                       hotkey="{'right': hotkeyClick}"
                       hotkey-description="${message(code: 'is.ui.backlogelement.toolbar.next')}"
                       href="{{ currentStateUrl(nextStory().id) }}">
                        <i class="fa fa-caret-right" defer-tooltip="${message(code: 'is.ui.backlogelement.toolbar.next')} (&#xf061;)"></i>
                    </a>
                    <a class="btn btn-secondary expandable"
                       ng-if="!isModal && !application.focusedDetailsView"
                       href="{{ toggleFocusUrl() }}"
                       tabindex="0"
                       hotkey="{'space': hotkeyClick, 'up': hotkeyClick}"
                       hotkey-description="${message(code: 'is.ui.window.focus')}">
                        <i class="fa fa-expand" defer-tooltip="${message(code: 'is.ui.window.focus')} (↑)"></i>
                    </a>
                    <a class="btn btn-secondary expandable"
                       ng-if="!isModal && application.focusedDetailsView"
                       href="{{ toggleFocusUrl() }}"
                       tabindex="0"
                       hotkey="{'escape': hotkeyClick, 'down': hotkeyClick}"
                       hotkey-description="${message(code: 'is.ui.window.unfocus')}">
                        <i class="fa fa-compress" defer-tooltip="${message(code: 'is.ui.window.unfocus')} (↓)"></i>
                    </a>
                    <details-layout-buttons ng-if="!isModal" remove-ancestor="true"/>
                </div>
                <div class="btn-group shortcut-menu" role="group">
                    <shortcut-menu ng-model="story" model-menus="menus" view-type="'details'"></shortcut-menu>
                    <div ng-class="['btn-group dropdown', {'dropup': application.minimizedDetailsView}]" uib-dropdown>
                        <button type="button" class="btn btn-secondary" uib-dropdown-toggle>
                        </button>
                        <div uib-dropdown-menu class="float-right" ng-init="itemType = 'story'" template-url="item.menu.html"></div>
                    </div>
                </div>
            </div>
        </h3>
        <a href="{{ tabUrl('activities') }}" class="story-states"><visual-states ng-model="story" model-states="storyStatesByName"/></a>
        <entry:point id="story-details-before-tabs"/>
    </div>
    <div class="details-content-container">
        <div class="details-content details-content-left">
            <ul class="nav nav-tabs nav-tabs-is nav-justified disable-active-link">
                <li role="presentation"
                    class="nav-item">
                    <a href="{{ tabUrl() }}"
                       class="nav-link"
                       ng-class="{'active':!$state.params.storyTabId}">
                        ${message(code: 'todo.is.ui.details')}
                    </a>
                </li>
                <li role="presentation"
                    class="nav-item">
                    <a href="{{ tabUrl('comments') }}"
                       class="nav-link"
                       ng-class="{'active':$state.params.storyTabId == 'comments'}">
                        ${message(code: 'todo.is.ui.comments')} {{ story.comments_count | parens }}
                    </a>
                </li>
                <li role="presentation"
                    class="nav-item hidden-sm"
                    ng-if="!application.focusedDetailsView"
                    uib-tooltip="${message(code: 'todo.is.ui.acceptanceTests')}">
                    <a href="{{ tabUrl('tests') }}"
                       class="nav-link"
                       ng-class="getAcceptanceTestClass(story)">
                        ${message(code: 'todo.is.ui.acceptanceTests.short')} {{ story.acceptanceTests_count | parens }}
                    </a>
                </li>
                <li role="presentation"
                    class="nav-item hidden-sm hidden-md"
                    ng-if="!application.focusedDetailsView">
                    <a href="{{ tabUrl('tasks') }}"
                       class="nav-link"
                       ng-class="{'active':$state.params.storyTabId == 'tasks'}">
                        ${message(code: 'todo.is.ui.tasks')} {{ story.tasks_count | parens }}
                    </a>
                </li>
                <li role="presentation"
                    class="nav-item dropdown display-on-hover">
                    <a class="nav-link dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"></a>
                    <ul class="dropdown-menu dropdown-more dropdown-menu-right">
                        <li role="presentation"
                            class="visible-sm-block"
                            uib-tooltip="${message(code: 'todo.is.ui.acceptanceTests')}"
                            ng-class="getAcceptanceTestClass(story)">
                            <a href="{{ tabUrl('tests') }}">
                                ${message(code: 'todo.is.ui.acceptanceTests')} {{ story.acceptanceTests_count | parens }}
                            </a>
                        </li>
                        <li role="presentation"
                            class="visible-sm-block visible-md-block"
                            ng-class="{'active':$state.params.storyTabId == 'tasks'}">
                            <a href="{{ tabUrl('tasks') }}">
                                ${message(code: 'todo.is.ui.tasks')} {{ story.tasks_count | parens }}
                            </a>
                        </li>
                        <li role="presentation" ng-class="{'active':$state.params.storyTabId == 'activities'}">
                            <a href="{{ tabUrl('activities') }}">
                                ${message(code: 'todo.is.ui.history')}
                            </a>
                        </li>
                        <entry:point id="story-details-tab-button"/>
                    </ul>
                </li>
            </ul>
            <div ui-view="details-tab-left">
                <g:include view="story/templates/_story.properties.gsp"/>
            </div>
        </div>
        <div ng-if="application.focusedDetailsView" class="details-content details-content-center">
            <ul class="nav nav-tabs nav-tabs-is nav-justified disable-active-link">
                <li role="presentation"
                    class="nav-item">
                    <a href
                       class="nav-link"
                       ng-class="getAcceptanceTestClass(story)">
                        ${message(code: 'todo.is.ui.acceptanceTests')} {{ story.acceptanceTests_count | parens }}
                    </a>
                </li>
            </ul>
            <div ui-view="details-tab-center"></div>
        </div>
        <div ng-if="application.focusedDetailsView" class="details-content details-content-right">
            <ul class="nav nav-tabs nav-tabs-is nav-justified disable-active-link">
                <li role="presentation"
                    class="nav-item">
                    <a href
                       class="nav-link">
                        ${message(code: 'todo.is.ui.tasks')} {{ story.tasks_count | parens }}
                    </a>
                </li>
            </ul>
            <div ui-view="details-tab-right"></div>
        </div>
    </div>
</div>
</script>