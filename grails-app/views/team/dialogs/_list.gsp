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

<is:modal title="${message(code: 'is.ui.team.menu')}"
          class="modal-split"
          footer="${false}">
    <div class="row">
        <div class="col-sm-3 modal-split-left">
            <div class="modal-split-search">
                <input type="text"
                       ng-model="teamSearch"
                       ng-change="searchTeams()"
                       ng-model-options="{debounce: 300}"
                       class="form-control search-input"
                       placeholder="${message(code: 'todo.is.ui.search.action')}">
            </div>
            <ul class="nav nav-pills nav-fill flex-column">
                <li class="nav-item"
                    ng-repeat="currentTeam in teams">
                    <a class="nav-link"
                       ng-class="{ 'active': team.id == currentTeam.id }"
                       ng-click="selectTeam(currentTeam)" href>{{ currentTeam.name }}</a>
                </li>
            </ul>
            <div class="modal-split-pagination">
                <div uib-pagination
                     boundary-links="true"
                     previous-text="&lsaquo;" next-text="&rsaquo;" first-text="&laquo;" last-text="&raquo;"
                     class="pagination-sm justify-content-center mt-2"
                     max-size="3"
                     total-items="totalTeams"
                     items-per-page="teamsPerPage"
                     ng-model="currentPage"
                     ng-change="searchTeams()">
                </div>
            </div>
        </div>
        <div class="col-sm-9 modal-split-right" ng-switch="teamSelected()">
            <div ng-switch-default>
                <div class="form-text">
                    ${message(code: 'is.ui.team.help')}
                    <documentation doc-url="roles-teams-projects"/>
                </div>
                <form ng-submit="save(newTeam)"
                      name="formHolder.newTeamForm"
                      show-validation
                      novalidate>
                    <div class="form-group">
                        <label for="team.name">${message(code: 'is.ui.team.create.name')}</label>
                        <input required
                               ng-maxlength="100"
                               name="team.name"
                               ng-model="newTeam.name"
                               type="text"
                               class="form-control">
                    </div>
                    <div class="btn-toolbar float-right">
                        <button class="btn btn-primary float-right"
                                ng-disabled="!formHolder.newTeamForm.$dirty || formHolder.newTeamForm.$invalid || application.submitting"
                                type="submit">
                            ${message(code: 'default.button.create.label')}
                        </button>
                    </div>
                </form>
            </div>
            <div ng-switch-when="true">
                <p class="form-text">
                    ${message(code: 'is.ui.user.add' + (grailsApplication.config.icescrum.invitation.enable ? '' : '.invite'))}
                </p>
                <form ng-submit="update(team)"
                      name="formHolder.updateTeamForm"
                      show-validation
                      novalidate>
                    <div class="row is-form-row">
                        <div class="form-half">
                            <label for="team.name">${message(code: 'todo.is.ui.name')}</label>
                            <input required
                                   ng-maxlength="100"
                                   name="team.name"
                                   ng-model="team.name"
                                   type="text"
                                   class="form-control">
                        </div>
                        <div class="form-half">
                            <label for="team.owner">
                                ${message(code: 'is.role.owner')}
                                <entry:point id="team-list-owner"/>
                            </label>
                            <span class="form-control-plaintext"
                                  ng-if="!authorizedTeam('changeOwner', team)">{{ team.owner | userFullName }}</span>
                            <ui-select class="form-control"
                                       name="owner"
                                       ng-if="authorizedTeam('changeOwner', team)"
                                       ng-model="team.owner">
                                <ui-select-match>{{ $select.selected | userFullName }}</ui-select-match>
                                <ui-select-choices repeat="ownerCandidate in ownerCandidates">{{ ownerCandidate | userFullName }}</ui-select-choices>
                            </ui-select>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>${message(code: 'is.ui.projects')}</label>
                        <div class="form-control-plaintext"
                             ng-if="projects.length">
                            <span ng-repeat="project in projects">
                                <a ng-if="isCurrentProject(project)"
                                   class="link"
                                   href
                                   ng-click="$close(true); showProjectEditModal('team')">
                                    <strong>{{ project.name + ($last ? '' : ',') }}</strong>
                                </a>
                                <a ng-if="!isCurrentProject(project)"
                                   class="link"
                                   ng-href="{{ project.pkey | projectUrl }}">
                                    {{ project.name + ($last ? '' : ',') }}
                                </a>
                            </span>
                        </div>
                        <div ng-if="projects != undefined && !projects.length">
                            <a class="btn btn-primary btn-sm"
                               ng-click="$close(true)"
                               ui-sref="newProject">
                                ${message(code: 'todo.is.ui.project.createNew')}
                            </a>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="member.search">${message(code: 'todo.is.ui.select.member')}</label>
                        <p class="input-group">
                            <input autocomplete="off"
                                   type="text"
                                   name="member.search"
                                   id="member.search"
                                   autofocus
                                   class="form-control"
                                   placeholder="${message(code: 'is.ui.user.search.placeholder' + (grailsApplication.config.icescrum.user.search.enable ? '' : '.email'))}"
                                   ng-model="member.name"
                                   uib-typeahead="member as member.name for member in searchMembers($viewValue)"
                                   typeahead-loading="searchingMember"
                                   typeahead-min-length="2"
                                   typeahead-wait-ms="250"
                                   typeahead-on-select="addTeamMember($item, $model, $label)"
                                   typeahead-template-url="select.member.html">
                            <span class="input-group-append">
                                <span class="input-group-text">
                                    <i class="fa" ng-class="{ 'fa-search': !searchingMember, 'fa-refresh':searchingMember, 'fa-close':member.name }"></i>
                                </span>
                            </span>
                        </p>
                    </div>
                    <table ng-if="team.members.length" class="table table-striped table-sm">
                        <thead>
                            <tr>
                                <th colspan="2">${message(code: 'is.ui.team.members')} ({{ team.members.length }})</th>
                                <th class="text-right" style="font-weight: normal">${message(code: 'is.role.scrumMaster')}</th>
                            </tr>
                        </thead>
                        <tbody ng-repeat="member in team.members"
                               ng-include="'wizard.members.list.html'">
                        </tbody>
                    </table>
                    <div ng-if="team.members.length == 0">
                        ${message(code: 'todo.is.ui.team.no.members')}
                    </div>
                    <div class="btn-toolbar float-right">
                        <button class="btn btn-secondary"
                                type="button"
                                ng-click="cancel()">
                            ${message(code: 'is.button.cancel')}
                        </button>
                        <button ng-if="authorizedTeam('delete', team) && team.projects_count == 0"
                                class="btn btn-danger"
                                type="button"
                                ng-click="confirmDelete({ callback: delete, args: [team] })">
                            ${message(code: 'default.button.delete.label')}
                        </button>
                        <button class="btn btn-primary"
                                ng-disabled="!formHolder.updateTeamForm.$dirty || formHolder.updateTeamForm.$invalid || application.submitting"
                                type="submit">
                            ${message(code: 'default.button.update.label')}
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</is:modal>
