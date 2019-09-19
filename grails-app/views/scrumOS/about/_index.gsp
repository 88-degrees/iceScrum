%{--
- Copyright (c) 2014 Kagilum SAS
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
--}%
<is:modal name="about" title="${message(code: 'is.ui.about.title', args: [versionNumber])}">
    <uib-tabset active="active" type="pills" justified="true">
        <uib-tab index="0" heading="${message(code: 'is.dialog.about.warnings')}">
            <g:render template="/${controllerName}/about/warnings"/>
        </uib-tab>
        <entry:point id="about-first-tab"/>
%{--        <uib-tab index="10" heading="${message(code: 'todo.is.ui.release.notes')}">--}%
%{--            <g:render template="/${controllerName}/about/releaseNotes" model="[releaseNotes: about.releaseNotes]"/>--}%
%{--        </uib-tab>--}%
        <uib-tab index="11" heading="${message(code: 'is.dialog.about.help')}">
            <g:render template="/${controllerName}/about/help" model="[version: about.version, versionNumber: versionNumber, server: server, configLocation: configLocation]"/>
        </uib-tab>
        <uib-tab index="12" heading="${message(code: 'is.dialog.about.legal')}">
            <div class="about-legal">
                ${about.license.text().encodeAsNL2BR()}
            </div>
        </uib-tab>
        <entry:point id="about-last-tab"/>
    </uib-tabset>
</is:modal>