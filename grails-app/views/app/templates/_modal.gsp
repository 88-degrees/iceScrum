%{--
- Copyright (c) 2017 Kagilum.
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

<script type="text/ng-template" id="apps.modal.html">
<is:modal title="${message(code: 'is.ui.apps')}"
          class="apps-modal split-modal">
    <div class="row" ng-class="{'hide-left-card': !appDefinition}">
        <div class="left-card">
            <div class="left-card-header">
                <div class="input-group">
                    <input type="text"
                           ng-model="holder.appSearch"
                           name="app-search-input"
                           value="{{ holder.appSearch }}"
                           class="form-control"
                           placeholder="${message(code: 'todo.is.ui.search.action')}">
                    <span class="input-group-append">
                        <button class="btn btn-secondary btn-sm"
                                type="button"
                                ng-click="searchApp('')">
                            <i class="fa" ng-class="holder.appSearch ? 'fa-times' : 'fa-search'"></i>
                        </button>
                    </span>
                </div>
            </div>
            <ul class="left-card-body nav nav-list">
                <div class="text-center more-results" ng-hide="filteredApps.length">
                    <a href="${message(code: 'is.ui.apps.store.query')}{{ holder.appSearch }}">${message(code: 'is.ui.apps.store.search')}</a>
                </div>
                <li ng-class="{'current': currentAppDefinition == appDefinition}"
                    ng-repeat="currentAppDefinition in filteredApps = (appDefinitions | filter:appDefinitionFilter | orderBy: appsOrder)">
                    <a ng-click="openAppDefinition(currentAppDefinition)" href class="text-ellipsis">
                        {{:: currentAppDefinition.name }}
                        <i ng-if="isEnabledApp(currentAppDefinition)" class="fa fa-check text-success"></i>
                    </a>
                    <div class="ribbon">
                        <div class="new-app" ng-if="currentAppDefinition.isNew && !isEnabledApp(currentAppDefinition)">${message(code: 'is.ui.apps.new')}</div>
                        <div class="enabled-app" ng-if="isEnabledApp(currentAppDefinition)">${message(code: 'is.ui.apps.enabled')}</div>
                    </div>
                </li>
            </ul>
        </div>
        <div class="right-card">
            <div ng-if="appDefinition" class="app-details">
                <div ng-include="'app.details.html'"></div>
            </div>
            <div ng-if="!appDefinition">
                <div ng-include="'app.list.html'"></div>
            </div>
        </div>
    </div>
</is:modal>
</script>