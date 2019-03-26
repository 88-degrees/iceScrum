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
<form ng-submit="update(editableStory)"
      name='formHolder.storyForm'
      ng-class="{'form-editable': formEditable(), 'form-editing': formHolder.editing }"
      show-validation
      novalidate>
    <div class="card-body">
        <div class="row">
            <entry:point id="story-properties-before-properties"/>
            <div class="form-2-tiers">
                <label for="name">${message(code: 'is.story.name')}</label>
                <input required
                       ng-maxlength="100"
                       ng-focus="editForm(true)"
                       ng-disabled="!formEditable()"
                       name="name"
                       ng-model="editableStory.name"
                       type="text"
                       class="form-control">
            </div>
            <div class="form-1-tier">
                <label for="type">${message(code: 'is.story.type')}</label>
                <ui-select class="form-control"
                           ng-click="editForm(true)"
                           ng-disabled="!formEditable() || !authorizedStory('updateType', editableStory)"
                           name="type"
                           ng-model="editableStory.type">
                    <ui-select-match><i class="fa fa-{{ $select.selected | storyTypeIcon }}"></i> {{ $select.selected | i18n:'StoryTypes' }}</ui-select-match>
                    <ui-select-choices repeat="storyType in storyTypes | newStoryTypes"><i class="fa fa-{{ ::storyType | storyTypeIcon }}"></i> {{ ::storyType | i18n:'StoryTypes' }}</ui-select-choices>
                </ui-select>
            </div>
        </div>
        <div class="form-group">
            <label for="description">
                <span class="text-muted small float-right"
                      ng-click="showProjectEditModal('actors')">
                    <i class="fa fa-question-circle"></i> ${message(code: 'is.actor.help.description')}
                </span>
                <div>${message(code: 'is.backlogelement.description')}</div>
            </label>
            <textarea class="form-control"
                      ng-maxlength="3000"
                      name="description"
                      ng-model="editableStory.description"
                      ng-show="showDescriptionTextarea"
                      ng-blur="blurDescription()"
                      at="atOptions"
                      autofocus
                      placeholder="${message(code: 'is.ui.backlogelement.nodescription')}"></textarea>
            <div class="atwho-preview form-control"
                 ng-show="!showDescriptionTextarea"
                 ng-click="clickDescriptionPreview($event)"
                 ng-focus="focusDescriptionPreview($event)"
                 ng-mousedown="$parent.descriptionPreviewMouseDown = true"
                 ng-mouseup="$parent.descriptionPreviewMouseDown = false"
                 ng-class="{'placeholder': !editableStory.description}"
                 tabindex="0"
                 ng-bind-html="editableStory.description ? (editableStory.description | lineReturns | actorTag: actors) : '${message(code: 'is.ui.backlogelement.nodescription')}'"></div>
        </div>
        <div class="row">
            <div class="form-half">
                <label for="feature">${message(code: 'is.feature')}</label>
                <div ng-class="{'input-group': editableStory.feature.id && !isModal}">
                    <ui-select input-group-fix-width="38"
                               ng-click="editForm(true)"
                               uis-open-close="isOpen && listFeatures()"
                               ng-change="editForm(true)"
                               ng-disabled="!formEditable()"
                               class="form-control"
                               name="feature"
                               search-enabled="true"
                               ng-model="editableStory.feature">
                        <ui-select-match allow-clear="{{ formHolder.editing }}"
                                         title="{{ $select.selected.name }}"
                                         placeholder="${message(code: 'is.ui.story.nofeature')}">
                            <i class="fa fa-puzzle-piece" ng-style="{color: $select.selected.color}"></i> {{ $select.selected.name }}
                        </ui-select-match>
                        <ui-select-choices repeat="feature in features | orFilter: { name: $select.search, uid: $select.search }">
                            <i class="fa fa-puzzle-piece" ng-style="{color: feature.color}"></i> <span ng-bind-html="feature.name | highlight: $select.search"></span>
                        </ui-select-choices>
                    </ui-select>
                    <span class="input-group-append" ng-if="editableStory.feature.id && !isModal">
                        <a href="{{ storyFeatureUrl(editableStory) }}"
                           class="btn btn-secondary btn-sm">
                            <i class="fa fa-info-circle"></i>
                        </a>
                    </span>
                </div>
            </div>
            <div class="form-half">
                <label for="dependsOn">
                    ${message(code: 'is.story.dependsOn')}
                    <span class="text-muted small float-right" ng-if="project.portfolio.id"><i class="fa fa-question-circle"></i> ${message(code: 'is.ui.story.dependsOn.help')}</span>
                </label>
                <div ng-class="{'input-group':editableStory.dependsOn.id}">
                    <ui-select input-group-fix-width="38"
                               class="form-control"
                               ng-click="editForm(true); searchDependenceEntries(editableStory, $select)"
                               ng-change="editForm(true)"
                               ng-disabled="!formEditable()"
                               name="dependsOn"
                               search-enabled="true"
                               ng-model="editableStory.dependsOn">
                        <ui-select-match allow-clear="{{ formHolder.editing }}"
                                         title="{{ $select.selected | storyLabel : false : !hasSameProject(editableStory, $select.selected) }}"
                                         placeholder="${message(code: 'is.ui.story.nodependence')}">
                            {{ $select.selected | storyLabel : true : !hasSameProject(editableStory, $select.selected) }}
                        </ui-select-match>
                        <ui-select-choices refresh="searchDependenceEntries(editableStory, $select)"
                                           refresh-delay="100"
                                           repeat="dependenceEntry in dependenceEntries">
                            <i class="fa fa-sticky-note" ng-style="{color: dependenceEntry.feature ? dependenceEntry.feature.color : '#f9f157'}"></i>
                            <span ng-bind-html="dependenceEntry | storyLabel : false : !hasSameProject(editableStory, dependenceEntry) | highlight: $select.search"></span>
                        </ui-select-choices>
                    </ui-select>
                    <span class="input-group-append" ng-if="editableStory.dependsOn.id">
                        <a ng-if="hasSameProject(editableStory, editableStory.dependsOn)"
                           ui-sref=".({storyId: editableStory.dependsOn.id})"
                           class="btn btn-secondary btn-sm">
                            <i class="fa fa-info-circle"></i>
                        </a>
                        <a ng-if="!hasSameProject(editableStory, editableStory.dependsOn)"
                           ng-href="{{ editableStory.dependsOn.uid | permalink: 'story': editableStory.dependsOn.project.pkey }}"
                           class="btn btn-secondary">
                            <i class="fa fa-info-circle"></i>
                        </a>
                    </span>
                </div>
            </div>
        </div>
        <div class="form-group" ng-if="editableStory.dependences.length">
            <label>${message(code: 'is.story.dependences')}</label>
            <div class="form-control-plaintext">
                <span ng-repeat="dependence in editableStory.dependences track by dependence.id">
                    <a ng-if="hasSameProject(editableStory, dependence)"
                       ui-sref=".({storyId: dependence.id})"
                       title="{{ dependence | storyLabel }}">
                        {{ dependence.name | ellipsis: 30 }}</a><span ng-if="!$last">,</span>
                    <a ng-if="!hasSameProject(editableStory, dependence)"
                       ng-href="{{ dependence.uid | permalink: 'story': dependence.project.pkey }}"
                       title="{{ dependence | storyLabel : false : true }}">
                        {{ (dependence.name + ' (' +  dependence.project.name + ')') | ellipsis: 30 }}</a><span ng-if="!$last">,</span>
                </span>
            </div>
        </div>
        <div class="form-group" ng-if="showTags">
            <label for="tags">
                <entry:point id="item-properties-inside-tag"/>
                ${message(code: 'is.backlogelement.tags')}
            </label>
            <ui-select ng-click="retrieveTags(); editForm(true)"
                       ng-disabled="!formEditable()"
                       class="form-control"
                       name="tags"
                       multiple
                       tagging
                       tagging-tokens="SPACE|,"
                       tagging-label="${message(code: 'todo.is.ui.tag.create')}"
                       ng-model="editableStory.tags">
                <ui-select-match placeholder="${message(code: 'is.ui.backlogelement.notags')}">{{ $item }}</ui-select-match>
                <ui-select-choices repeat="tag in tags | filter: $select.search">
                    <span ng-bind-html="tag | highlight: $select.search"></span>
                </ui-select-choices>
            </ui-select>
        </div>
        <entry:point id="story-properties-after-tag"/>
        <div class="row">
            <div class="form-1-quarter" ng-show="editableStory.state > storyStatesByName.SUGGESTED">
                <label for="effort">${message(code: 'is.story.effort')}</label>
                <div class="input-group">
                    <ui-select ng-if="!isEffortCustom()"
                               class="form-control"
                               ng-click="editForm(true)"
                               ng-disabled="!formEditable() || !authorizedStory('updateEstimate', editableStory)"
                               name="effort"
                               search-enabled="true"
                               ng-model="editableStory.effort">
                        <ui-select-match placeholder="?">{{ $select.selected }}</ui-select-match>
                        <ui-select-choices repeat="i in effortSuite(isEffortNullable(story)) | filter: $select.search">
                            <span ng-bind-html="'' + i | highlight: $select.search"></span>
                        </ui-select-choices>
                    </ui-select>
                    <input type="number"
                           ng-if="isEffortCustom()"
                           class="form-control"
                           ng-focus="editForm(true)"
                           ng-disabled="!formEditable() || !authorizedStory('updateEstimate', editableStory)"
                           name="effort"
                           min="0"
                           ng-model="editableStory.effort"/>
                    <span class="input-group-append">
                        <button class="btn btn-secondary btn-sm"
                                ng-if="authorizedStory('updateEstimate', editableStory)"
                                type="button"
                                name="edit-effort"
                                ng-click="showEditEffortModal(story)"><i class="fa fa-pencil"></i></button>
                    </span>
                </div>
            </div>
            <div class="form-3-quarters" ng-show="editableStory.state > storyStatesByName.ACCEPTED">
                <label for="parentSprint"><i class="fa fa-tasks"></i> ${message(code: 'is.sprint')}</label>
                <ui-select ng-click="retrieveParentSprintEntries(); editForm(true)"
                           ng-change="editForm(true)"
                           ng-disabled="!formEditable() || !authorizedStory('updateParentSprint', editableStory)"
                           class="form-control"
                           name="parentSprint"
                           search-enabled="true"
                           ng-model="editableStory.parentSprint">
                    <ui-select-match allow-clear="{{ formHolder.editing }}" placeholder="${message(code: 'is.ui.story.noparentsprint')}">
                        {{ $select.selected.parentReleaseName + ' - ' + ($select.selected | sprintName) }}
                    </ui-select-match>
                    <ui-select-choices group-by="'parentReleaseName'" repeat="parentSprintEntry in parentSprintEntries | filter: { index: $select.search }">
                        <span ng-bind-html="parentSprintEntry | sprintNameWithState | highlight: $select.search"></span>
                    </ui-select-choices>
                </ui-select>
            </div>
        </div>
        <div class="row">
            <div class="form-1-quarter">
                <label for="value">${message(code: 'is.story.value')}</label>
                <div class="input-group">
                    <ui-select class="form-control"
                               ng-click="editForm(true)"
                               ng-disabled="!formEditable()"
                               name="value"
                               search-enabled="true"
                               ng-model="editableStory.value">
                        <ui-select-match>{{ $select.selected }}</ui-select-match>
                        <ui-select-choices repeat="i in integerSuite | filter: $select.search">
                            <span ng-bind-html="'' + i | highlight: $select.search"></span>
                        </ui-select-choices>
                    </ui-select>
                    <span class="input-group-append" ng-if="authorizedStory('update', editableStory)">
                        <button class="btn btn-secondary btn-sm"
                                type="button"
                                name="edit-value"
                                ng-click="showEditValueModal(story)"><i class="fa fa-pencil"></i></button>
                    </span>
                </div>
            </div>
            <div class="form-1-quarter" ng-show="editableStory.type == storyTypesByName.DEFECT">
                <label for="affectVersion">${message(code: 'is.story.affectVersion')}</label>
                <ui-select class="form-control"
                           ng-click="retrieveVersions(); editForm(true)"
                           ng-change="editForm(true)"
                           ng-disabled="!formEditable()"
                           search-enabled="true"
                           name="affectVersion"
                           tagging
                           tagging-tokens="SPACE|,"
                           tagging-label="${message(code: 'todo.is.ui.story.affectedVersion.new')}"
                           ng-model="editableStory.affectVersion">
                    <ui-select-match allow-clear="{{ formHolder.editing }}" placeholder="${message(code: 'is.ui.story.noaffectversion')}">{{ $select.selected }}</ui-select-match>
                    <ui-select-choices repeat="version in versions | filter: $select.search">
                        <span ng-bind-html="version | highlight: $select.search"></span>
                    </ui-select-choices>
                </ui-select>
            </div>
            <div class="form-half">
                <label for="creator">${message(code: 'is.story.creator')}</label>
                <div class="d-flex">
                    <img ng-src="{{ editableStory.creator | userAvatar }}" class="mr-2 {{ editableStory.creator | userColorRoles }}" height="32px"/>
                    <ui-select ng-click="editForm(true);searchCreator($select)"
                               ng-change="editForm(true)"
                               ng-disabled="!formEditable() || !authorizedStory('updateCreator', editableStory)"
                               class="form-control"
                               name="creator"
                               search-enabled="true"
                               ng-model="editableStory.creator">
                        <ui-select-match title="{{ $select.selected | userFullName }}">
                            {{ $select.selected | userFullName }}
                        </ui-select-match>
                        <ui-select-choices refresh="searchCreator($select)"
                                           refresh-delay="100"
                                           repeat="creator in creators | orFilter: { username: $select.search, name: $select.search, email: $select.search }">
                            <span ng-bind-html="(creator | userFullName) | highlight: $select.search"></span>
                        </ui-select-choices>
                    </ui-select>
                </div>
            </div>
        </div>
        <div class="form-group">
            <label for="notes">${message(code: 'is.backlogelement.notes')}</label>
            <textarea at
                      is-markitup
                      ng-maxlength="5000"
                      class="form-control"
                      name="notes"
                      ng-model="editableStory.notes"
                      is-model-html="editableStory.notes_html"
                      ng-show="showNotesTextarea"
                      ng-blur="showNotesTextarea = false"
                      placeholder="${message(code: 'is.ui.backlogelement.nonotes')}"></textarea>
            <div class="markitup-preview form-control"
                 ng-disabled="!formEditable()"
                 ng-show="!showNotesTextarea"
                 ng-click="showNotesTextarea = formEditable()"
                 ng-focus="editForm(true); showNotesTextarea = formEditable()"
                 ng-class="{'placeholder': !editableStory.notes_html}"
                 tabindex="0"
                 ng-bind-html="editableStory.notes_html ? editableStory.notes_html : '<p>${message(code: 'is.ui.backlogelement.nonotes')}</p>'"></div>
        </div>
        <div class="form-group">
            <label><i class="fa fa-paperclip"></i> ${message(code: 'is.backlogelement.attachment')} {{ story.attachments_count > 0 ? '(' + story.attachments.length + ')' : '' }}</label>
            <div ng-if="authorizedStory('upload', story)" ng-controller="attachmentNestedCtrl">
                <button type="button"
                        class="btn btn-secondary"
                        flow-btn>
                    <i class="fa fa-upload"></i> ${message(code: 'todo.is.ui.new.upload')}
                </button>
                <entry:point id="attachment-add-buttons"/>
            </div>
            <div class="form-control-plaintext" ng-include="'attachment.list.html'">
            </div>
        </div>
    </div>
    <div class="card-footer" ng-if="isModal || formHolder.editing">
        <div class="btn-toolbar" ng-class="[{ 'text-right' : isModal }]">
            <button class="btn btn-secondary"
                    type="button"
                    ng-if="isModal && !isDirty()"
                    ng-click="$close()">
                ${message(code: 'is.button.close')}
            </button>
            <button class="btn btn-secondary"
                    type="button"
                    ng-if="(!isModal && formHolder.editing) || (isModal && isDirty())"
                    ng-click="editForm(false)">
                ${message(code: 'is.button.cancel')}
            </button>
            <button class="btn btn-warning"
                    type="button"
                    ng-if="isDirty() && !isLatest() && !application.submitting"
                    ng-click="resetStoryForm()">
                <i class="fa fa-warning"></i> ${message(code: 'default.button.refresh.label')}
            </button>
            <button class="btn btn-danger"
                    ng-if="formHolder.editing && !isLatest() && !application.submitting"
                    ng-disabled="!isDirty() || formHolder.storyForm.$invalid"
                    type="submit">
                ${message(code: 'default.button.override.label')}
            </button>
            <button class="btn btn-primary"
                    ng-if="formHolder.editing && (isLatest() || application.submitting)"
                    ng-disabled="!isDirty() || formHolder.storyForm.$invalid || application.submitting"
                    type="submit">
                ${message(code: 'default.button.update.label')}
            </button>
        </div>
    </div>
</form>
