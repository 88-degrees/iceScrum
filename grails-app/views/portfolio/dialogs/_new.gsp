<%@ page import="org.icescrum.core.support.ApplicationSupport" %>
%{--
- Copyright (c) 2014 Kagilum.
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


<is:modal icon="briefcase" title="{{ (portfolio.name ? portfolio.name : '${message(code: /is.dialog.wizard.portfolio/)}') + (portfolio.fkey ? ' - ' + portfolio.fkey : '') }}" class="modal-split" footer="${false}">
    <form name="formHolder.portfolioForm"
          show-validation
          novalidate>
        <wizard class="row" name="portfolio">
            <wz-step wz-title="${message(code: "is.dialog.wizard.section.portfolio")}">
                <ng-include src="'form.general.portfolio.html'"></ng-include>
                <div class="footer-btn-toolbar">
                    <div class="float-right btn-toolbar">
                        <button type="button"
                                role="button"
                                class="btn btn-secondary"
                                ng-click="$close()">
                            ${message(code: 'is.button.cancel')}
                        </button>
                        <input type="submit" class="btn btn-secondary" ng-disabled="formHolder.portfolioForm.$invalid" wz-next value="${message(code: 'todo.is.ui.wizard.next')}"/>
                    </div>
                </div>
            </wz-step>
            <wz-step wz-title="${message(code: "is.dialog.wizard.section.portfolio.projects")}">
                <ng-include src="'form.projects.portfolio.html'"></ng-include>
                <div class="footer-btn-toolbar">
                    <button type="button"
                            role="button"
                            class="btn btn-secondary float-left"
                            ng-click="$close()">
                        ${message(code: 'is.button.cancel')}
                    </button>
                    <div class="btn-toolbar float-right">
                        <button type="button"
                                role="button"
                                class="btn btn-secondary"
                                wz-previous="previous">
                            ${message(code: 'todo.is.ui.wizard.previous')}
                        </button>
                        <input type="submit" class="btn btn-secondary" ng-disabled="portfolio.projects.length < 1" wz-next value="${message(code: 'todo.is.ui.wizard.next')}"/>
                    </div>
                </div>
            </wz-step>
            <wz-step wz-title="${message(code: "is.dialog.wizard.section.portfolio.members")}">
                <ng-include src="'form.members.portfolio.html'"></ng-include>
                <div class="footer-btn-toolbar">
                    <button type="button"
                            role="button"
                            class="btn btn-secondary"
                            ng-click="$close()">
                        ${message(code: 'is.button.cancel')}
                    </button>
                    <div class="btn-toolbar float-right">
                        <button type="button"
                                role="button"
                                class="btn btn-secondary"
                                wz-previous="previous">
                            ${message(code: 'todo.is.ui.wizard.previous')}
                        </button>
                        <input type="submit"
                               class="btn btn-primary"
                               ng-disabled=""
                               wz-finish="createPortfolio(portfolio)"
                               value="${message(code: 'todo.is.ui.wizard.finish.portfolio')}"/>
                    </div>
                </div>
            </wz-step>
        </wizard>
    </form>
</is:modal>