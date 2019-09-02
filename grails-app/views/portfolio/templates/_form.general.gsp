<%@ page import="org.icescrum.core.domain.security.Authority; grails.plugin.springsecurity.SpringSecurityUtils; org.icescrum.core.support.ApplicationSupport" %>
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
<script type="text/ng-template" id="form.general.portfolio.html">
<h4>${message(code: "is.dialog.wizard.section.portfolio")}</h4>
<p class="form-text">${message(code: 'is.ui.portfolio.help.general')}</p>
<entry:point id="portfolio-form-general-before"/>
<div class="row">
    <div class="form-2-tiers">
        <label for="name">${message(code: 'is.portfolio.name')}</label>
        <div class="input-group">
            <input autofocus
                   name="name"
                   type="text"
                   class="form-control"
                   autocomplete="off"
                   placeholder="${message(code: 'is.ui.portfolio.noname')}"
                   ng-model="portfolio.name"
                   ng-change="nameChanged()"
                   ng-required="isCurrentStep(1, 'portfolio')">
            <span class="input-group-append">
                <span class="input-group-text">
                    ${message(code: 'is.ui.workspace.hidden')}
                </span>
            </span>
        </div>
    </div>
    <div class="form-1-tier">
        <label for="fkey">${message(code: 'is.portfolio.fkey')}</label>
        <input name="fkey"
               type="text"
               capitalize
               class="form-control"
               placeholder="${message(code: 'is.ui.portfolio.nokey')}"
               ng-model="portfolio.fkey"
               ng-pattern="/^[A-Z0-9]*[A-Z][A-Z0-9]*$/"
               pattern-error-message="${message(code: 'portfolio.fkey.matches.invalid')}"
               ng-required="isCurrentStep(1, 'portfolio')"
               autocomplete="off"
               ng-maxlength="10"
               ng-remote-validate-code="portfolio.fkey.unique"
               ng-remote-validate="{{ checkPortfolioPropertyUrl }}/fkey">
    </div>
</div>
<div class="row">
    <div class="col form-group">
        <label for="description">${message(code: 'is.portfolio.description')}</label>
        <textarea at
                  is-markitup
                  name="portfolio.description"
                  class="form-control"
                  placeholder="${message(code: 'is.ui.portfolio.description.placeholder')}"
                  ng-model="portfolio.description"
                  ng-show="showDescriptionTextarea"
                  ng-blur="delayCall(toggleDescription, [false])"
                  is-model-html="portfolio.description_html"></textarea>
        <div class="markitup-preview form-control"
             tabindex="0"
             ng-show="!showDescriptionTextarea"
             ng-click="toggleDescription(true)"
             ng-focus="toggleDescription(true)"
             ng-class="{'placeholder': !portfolio.description_html}"
             ng-bind-html="portfolio.description_html ? portfolio.description_html : '<p>${message(code: 'is.ui.portfolio.description.placeholder')}</p>'"></div>
    </div>
</div>
</script>
