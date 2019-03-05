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
<script type="text/ng-template" id="feature.new.html">
<div class="card">
    <div class="card-header">
        <h3 class="card-title row">
            <div class="left-title">
                <i class="fa fa-puzzle-piece" ng-style="{color: feature.color}"></i> <span class="item-name" title="${message(code: 'todo.is.ui.feature.new')}">${message(code: 'todo.is.ui.feature.new')}</span>
            </div>
            <div class="right-title">
                <details-layout-buttons ng-if="!isModal" remove-ancestor="!$state.includes('feature.**')"/>
            </div>
        </h3>
    </div>
    <div class="details-no-tab">
        <div class="card-body">
            <div class="form-text">
                ${message(code: 'is.ui.feature.help')}
                <documentation doc-url="features-stories-tasks#features"/>
            </div>
            <div class="sticky-notes standalone">
                <div class="sticky-note-container sticky-note-feature solo">
                    <div ng-style="feature.color | createGradientBackground"
                         class="sticky-note {{ feature.color | contrastColor }}">
                        <div class="sticky-note-head">
                            <span class="id">42</span>
                        </div>
                        <div class="sticky-note-content">
                            <h3 class="title">{{ feature.name }}</h3>
                        </div>
                        <div class="sticky-note-tags"></div>
                        <div class="sticky-note-actions">
                            <span class="action"><a><i class="fa fa-paperclip"></i></a></span>
                            <span class="action"><a><i class="fa fa-sticky-note"></i></a></span>
                            <span class="action"><a><i class="fa fa-ellipsis-h"></i></a></span>
                        </div>
                    </div>
                </div>
            </div>
            <form ng-submit="save(feature, false)"
                  name='formHolder.featureForm'
                  novalidate>
                <div class="clearfix no-padding">
                    <div class="form-group">
                        <label for="name">${message(code: 'is.feature.name')}</label>
                        <div class="input-group">
                            <input required
                                   name="name"
                                   autofocus
                                   ng-model="feature.name"
                                   type="text"
                                   class="form-control"
                                   ng-disabled="!authorizedFeature('create')"
                                   placeholder="${message(code: 'is.ui.feature.noname')}"/>
                            <span class="input-group-append">
                                <button colorpicker
                                        class="btn {{ feature.color | contrastColor }}"
                                        type="button"
                                        ng-style="{'background-color': feature.color}"
                                        colorpicker-position="left"
                                        colorpicker-with-input="true"
                                        ng-click="refreshAvailableColors()"
                                        colors="availableColors"
                                        name="color"
                                        ng-model="feature.color"><i class="fa fa-pencil"></i> ${message(code: 'todo.is.ui.color')}</button>
                            </span>
                        </div>
                    </div>
                </div>
                <entry:point id="feature-new-form"/>
                <div ng-if="authorizedFeature('create')" class="btn-toolbar float-right">
                    <button class="btn btn-primary"
                            ng-disabled="formHolder.featureForm.$invalid || application.submitting"
                            defer-tooltip="${message(code: 'todo.is.ui.create.and.continue')} (SHIFT+RETURN)"
                            hotkey="{'shift+return': hotkeyClick }"
                            hotkey-allow-in="INPUT"
                            hotkey-description="${message(code: 'todo.is.ui.create.and.continue')}"
                            type='button'
                            ng-click="save(feature, true)">
                        ${message(code: 'todo.is.ui.create.and.continue')}
                    </button>
                    <button class="btn btn-primary"
                            ng-disabled="formHolder.featureForm.$invalid || application.submitting"
                            type="submit">
                        ${message(code: 'default.button.create.label')}
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>
</script>
