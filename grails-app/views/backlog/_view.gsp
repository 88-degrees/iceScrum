<%@ page import="org.icescrum.core.domain.Story; grails.converters.JSON" %>
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
<div class="panel panel-light">
    <div class="panel-heading">
       <div class="btn-group">
           <a type="button"
              ng-if="authorizedStory('create')"
              uib-tooltip="${message(code:'default.button.create.label')}"
              tooltip-append-to-body="true"
              tooltip-placement="right"
              ng-click="goToNewStory()"
              class="btn btn-primary">
               <span class="fa fa-plus"></span>
           </a>
           <button type="button"
                   uib-tooltip="${message(code:'todo.is.ui.toggle.grid.list')}"
                   tooltip-append-to-body="true"
                   tooltip-placement="right"
                   ng-click="view.asList = !view.asList"
                   class="btn btn-default">
               <span class="fa fa-th" ng-class="{'fa-th-list': view.asList, 'fa-th': !view.asList}"></span>
           </button>
           <div class="btn-group"
                uib-dropdown
                is-open="orderBy.status"
                tooltip-append-to-body="true"
                uib-tooltip="${message(code:'todo.is.ui.sort')}">
               <button class="btn btn-default" uib-dropdown-toggle type="button">
                   <span id="sort">{{ orderBy.current.name }}</span>
                   <span class="caret"></span>
               </button>
               <ul class="uib-dropdown-menu" role="menu">
                   <li role="menuitem" ng-repeat="order in orderBy.values">
                       <a ng-click="orderBy.current = order; orderBy.status = false;" href>{{ order.name }}</a>
                   </li>
               </ul>
           </div>
           <button type="button" class="btn btn-default"
                   ng-click="orderBy.reverse = !orderBy.reverse"
                   uib-tooltip="${message(code:'todo.is.ui.order')}"
                   tooltip-append-to-body="true">
               <span class="fa fa-sort-amount{{ orderBy.reverse ? '-desc' : '-asc'}}"></span>
           </button>
       </div>
       <div class="btn-group" tooltip-append-to-body="true" uib-dropdown uib-tooltip="${message(code:'todo.is.ui.export')}">
           <button class="btn btn-default" uib-dropdown-toggle type="button">
               <span class="fa fa-download"></span>&nbsp;<span class="caret"></span>
           </button>
           <ul class="uib-dropdown-menu"
               role="menu">
               <g:each in="${is.exportFormats()}" var="format">
                   <li role="menuitem">
                       <a href="${createLink(action:format.action?:'print',controller:format.controller?:controllerName,params:format.params)}"
                          ng-click="print($event)">${format.name}</a>
                   </li>
               </g:each>
               <entry:point id="${controllerName}-toolbar-export" model="[product:params.product, origin:controllerName]"/>
           </ul>
       </div>
       <div class="btn-group pull-right visible-on-hover">
           <entry:point id="${controllerName}-${actionName}-toolbar-right"/>
           <g:if test="${params?.printable}">
               <button type="button"
                       class="btn btn-default"
                       uib-tooltip="${message(code:'is.ui.window.print')} (P)"
                       tooltip-append-to-body="true"
                       tooltip-placement="bottom"
                       ng-click="print($event)"
                       ng-href="{{ viewName }}/print"
                       hotkey="{'P': hotkeyClick }"><span class="fa fa-print"></span>
               </button>
           </g:if>
           <g:if test="${params?.fullScreen}">
               <button type="button"
                       class="btn btn-default"
                       ng-show="!app.isFullScreen"
                       ng-click="fullScreen()"
                       uib-tooltip="${message(code:'is.ui.window.fullscreen')} (F)"
                       tooltip-append-to-body="true"
                       tooltip-placement="bottom"
                       hotkey="{'F': fullScreen }"><span class="fa fa-expand"></span>
               </button>
               <button type="button"
                       class="btn btn-default"
                       ng-show="app.isFullScreen"
                       uib-tooltip="${message(code:'is.ui.window.fullscreen')}"
                       tooltip-append-to-body="true"
                       tooltip-placement="bottom"
                       ng-click="fullScreen()"><span class="fa fa-compress"></span>
               </button>
           </g:if>
       </div>
   </div>
   <div class="panel-body">
       <div id="backlog-layout-window-${controllerName}"
            ui-selectable="selectableOptions"
            ui-selectable-list="stories"
            html-sortable="storySortableOptions"
            html-sortable-callback="storySortableUpdate(startModel, destModel, start, end)"
            ng-model="filteredAndSortedStories"
            ng-class="view.asList ? 'list-group' : 'grid-group'"
            class="postits"
            ng-include="'story.html'"></div>
       <script>
           angular.element(document).injector().get('StoryService').addStories(${stories as JSON});
       </script>
   </div>
</div>
