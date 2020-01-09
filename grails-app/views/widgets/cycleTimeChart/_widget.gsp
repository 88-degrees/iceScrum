%{--
- Copyright (c) 2016 Kagilum SAS.
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

<is:widget widgetDefinition="${widgetDefinition}">
    <div ng-if="widgetReady(widget)" class="pieChartWidget">
        <div ng-init="display(widget)">
            <nvd3 options="options" data="data" config="{refreshDataOnly: false}"></nvd3>
            <div class="caption">${message(code: 'is.ui.widget.cycleTimeChart.name')}</div>
        </div>
    </div>
    <div ng-if="!widgetReady(widget) && authorizedWidget('update', widget)">
        <a href ng-click="toggleSettings(widget)"><h4 class="text-center"><g:message code="is.ui.widget.chart.no.chart"/></h4></a>
    </div>
    <div ng-if="!widgetReady(widget) && !authorizedWidget('update', widget)">
        <h4 class="text-center"><g:message code="is.ui.widget.chart.no.chart"/></h4>
    </div>
</is:widget>