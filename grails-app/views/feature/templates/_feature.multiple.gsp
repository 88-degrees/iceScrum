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
<script type="text/ng-template" id="feature.multiple.html">
<div class="card">
    <div class="card-header">
        <h3 class="card-title">
            ${message(code: "is.ui.feature")} ({{ features.length }})
            <a class="float-right btn btn-secondary"
               href="#/{{ ::viewName }}"
               defer-tooltip="${message(code: 'is.ui.window.closeable')}">
                <i class="fa fa-times"></i>
            </a>
        </h3>
    </div>
    <div class="details-no-tab">
        <div class="card-body">
            <div class="row">
                <div class="col-md-6">
                    <div class="sticky-notes standalone">
                        <div class="sticky-note-container sticky-note-feature stack twisted">
                            <div ng-style="topFeature.color | createGradientBackground"
                                 class="sticky-note {{ (topFeature.color | contrastColor) + ' ' + (featurePreview.type | featureType) }}">
                                <div class="sticky-note-head">
                                    <span class="id">{{ topFeature.uid }}</span>
                                </div>
                                <div class="sticky-note-content" ng-class="::{'has-description':!!feature.description}">
                                    <div class="item-values">
                                        <span ng-if="topFeature.value">
                                            ${message(code: 'is.feature.value')} <strong>{{  topFeature.value }}</strong>
                                        </span>
                                    </div>
                                    <h3 class="title">{{ topFeature.name }}</h3>
                                    <div class="description"
                                         ng-bind-html="topFeature.description | lineReturns"></div>
                                </div>
                                <div class="sticky-note-tags">
                                    <a ng-repeat="tag in topFeature.tags"
                                       href="{{ tagContextUrl(tag) }}">
                                        <span class="tag {{ getTagColor(tag, 'feature') | contrastColor }}"
                                              ng-style="{'background-color': getTagColor(tag, 'story') }">{{:: tag }}</span>
                                    </a>
                                </div>
                                <div class="sticky-note-actions">
                                    <span class="action"><a><i class="fa fa-cog"></i> <i class="fa fa-caret-down"></i></a></span>
                                    <span class="action" ng-class="{'active':topFeature.attachments_count}">
                                        <a defer-tooltip="${message(code: 'todo.is.ui.backlogelement.attachments')}">
                                            <i class="fa fa-paperclip"></i>
                                        </a>
                                    </span>
                                    <span class="action" ng-class="{'active':topFeature.stories_ids.length}">
                                        <a defer-tooltip="${message(code: 'todo.is.ui.stories')}">
                                            <i class="fa fa-tasks"></i>
                                            <span class="badge">{{ topFeature.stories_ids.length || ''}}</span>
                                        </a>
                                    </span>
                                </div>
                                <div class="sticky-note-state-progress">
                                    <div class="state">{{ topFeature.state | i18n:'FeatureStates' }}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="btn-toolbar">
                        <entry:point id="feature-multiple-toolbar"/>
                        <div ng-if="authorizedFeature('delete')"
                             class="btn-group">
                            <button type="button"
                                    class="btn btn-secondary"
                                    ng-click="confirmDelete({ callback: deleteMultiple })">
                                ${message(code: 'default.button.delete.label')}
                            </button>
                        </div>
                    </div>
                    <br/>
                    <div class="table-responsive">
                        <table class="table">
                            <tr><td>${message(code: 'is.feature.value')}</td><td>{{ sumValues(features) }}</td></tr>
                            <tr><td>${message(code: 'todo.is.ui.stories')}</td><td>{{ sumStories(features) }}</td></tr>
                        </table>
                    </div>
                </div>
            </div>
            <form ng-submit="updateMultiple(featurePreview)"
                  ng-if="authorizedFeature('update')"
                  name='featureForm'
                  show-validation
                  novalidate>
                <div class="row is-form-row">
                    <div class="form-half">
                        <label for="type">${message(code: 'is.feature.type')}</label>
                        <ui-select class="form-control"
                                   name="type"
                                   ng-model="featurePreview.type">
                            <ui-select-match placeholder="${message(code: 'todo.is.ui.feature.type.placeholder')}">{{ $select.selected | i18n:'FeatureTypes' }}</ui-select-match>
                            <ui-select-choices repeat="featureType in featureTypes">{{ featureType | i18n:'FeatureTypes' }}</ui-select-choices>
                        </ui-select>
                    </div>
                </div>
                <div class="form-group" ng-if="showTags">
                    <label for="tags">
                        <entry:point id="item-properties-inside-tag"/>
                        ${message(code: 'is.backlogelement.tags')}
                    </label>
                    <ui-select ng-click="retrieveTags()"
                               class="form-control"
                               name="tags"
                               multiple
                               tagging
                               tagging-tokens="SPACE|,"
                               tagging-label="${message(code: 'todo.is.ui.tag.create')}"
                               ng-model="featurePreview.tags">
                        <ui-select-match placeholder="${message(code: 'is.ui.backlogelement.notags')}">{{ $item }}</ui-select-match>
                        <ui-select-choices repeat="tag in tags | filter: $select.search">
                            <span ng-bind-html="tag | highlight: $select.search"></span>
                        </ui-select-choices>
                    </ui-select>
                </div>
                <entry:point id="feature-multiple-properties-after-tag"/>
                <div class="btn-toolbar">
                    <button class="btn btn-primary float-right"
                            type="submit"
                            ng-disabled="!featureForm.$dirty || featureForm.$invalid || application.submitting">
                        ${message(code: 'default.button.update.label')}
                    </button>
                    <a class="btn btn-secondary float-right"
                       href="#/{{ ::viewName }}">
                        ${message(code: 'is.button.cancel')}
                    </a>
                </div>
            </form>
        </div>
    </div>
</div>
</script>