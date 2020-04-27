<%@ page import="grails.util.Holders" %>
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


<is:modal title="${message(code: 'is.ui.workspace.choose')}"
          footer="${false}"
          class="modal-workspace-wizard">
    <div class="row workspace-wizard-header justify-content-center align-items-center">
            <button class="btn btn-secondary"
                    ng-disabled="application.submitting"
                    defer-tooltip="${message(code: 'is.ui.workspace.description.sampleProject')}"
                    type="button"
                    tabindex="-1"
                    ng-click="createSampleProject()">
                ${message(code: 'is.ui.workspace.new.sampleProject')}
            </button>
    </div>
    <div class="row">
        <g:each var="workspace" in="${Holders.grailsApplication.config.icescrum.workspaces}" status="i">
            <div class="workspace col-md-6 text-center">
                <div class="workspace-image ${workspace.key}"></div>
                <h3>${message(code: 'is.' + workspace.key)}</h3>
                <p>${g.message(code: 'is.ui.workspace.description.' + workspace.key)}</p>
                <button class="btn btn-primary" ${workspace.value.enabled(Holders.grailsApplication) ? '' : 'disabled="disabled"'}
                        type="button"
                        ng-click="openWizard('new${workspace.key.capitalize()}')">
                    ${g.message(code: 'is.ui.workspace.new.' + workspace.key)}
                </button>
                <g:if test="${!workspace.value.enabled(Holders.grailsApplication)}">
                    <a class="link" target="_blank" href="https://www.icescrum.com/pricing/">
                        <div class="text-muted">
                            <i class="fa fa-info-circle"></i> ${g.message(code: 'is.ui.workspace.disabled.' + workspace.key)}
                        </div>
                    </a>
                </g:if>
            </div>
        </g:each>
    </div>
    <g:if test="${Holders.grailsApplication.config.icescrum.workspaces.size() > 1}">
        <div class="text-center workspace-help">
            <a target="_blank"
               class="text-primary"
               href="https://www.icescrum.com/documentation/manage-product-development/">
                ${g.message(code: 'is.ui.workspace.choose.help')}
            </a>
        </div>
    </g:if>
</is:modal>