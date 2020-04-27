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

<script type="text/ng-template" id="edit.administration.project.html">
<form role='form'
      ng-controller="editProjectCtrl"
      show-validation
      novalidate
      ng-submit='update(project)'
      name="formHolder.editProjectForm">
    <entry:point id="project-edit-administration"/>
    <h4 class="mb-2">${message(code: "is.project.preferences.project.stakeHolderAccess")}</h4>
    <table class="table table-striped" ng-class="{'disabled': !stakeHolderViewsFormEnabled}">
        <tr>
            <th ng-class="{'text-muted': !stakeHolderViewsFormEnabled}">${message(code: 'is.project.preferences.project.stakeHolderRestrictedViews')}</th>
            <th></th>
        </tr>
        <tr ng-repeat="view in stakeHolderViews">
            <td ng-class="{'text-muted':!view.hidden || !stakeHolderViewsFormEnabled }">{{ view.title }}</td>
            <td class="text-right"><input type="checkbox" name="view.hidden" ng-model="view.hidden" ng-disabled="!stakeHolderViewsFormEnabled"></td>
        </tr>
    </table>
    <h4 class="mb-2">${message(code: "is.ui.danger.zone")}</h4>
    <div class="btn-toolbar">
        <button ng-if="authorizedProject('delete', project)"
                type="button"
                role="button"
                class="btn btn-danger btn-sm"
                delete-button-click="delete(project)">
            ${message(code: 'is.projectmenu.submenu.project.delete')}
        </button>
        <button ng-if="!project.preferences.archived"
                type="button"
                role="button"
                class="btn btn-danger btn-sm"
                delete-button-click="archive(project)">
            ${message(code: 'is.dialog.project.archive.button')}
        </button>
        <button ng-if="project.preferences.archived && authorizedProject('unArchive', project)"
                type="button"
                class="btn btn-danger btn-sm"
                ng-click="unArchive(project)">
            ${message(code: 'is.dialog.project.unArchive.button')}
        </button>
    </div>
    <div class="btn-toolbar float-right">
        <button type="button"
                role="button"
                class="btn btn-secondary"
                ng-click="$close()">
            ${message(code: 'is.button.cancel')}
        </button>
        <button type='submit'
                role="button"
                class='btn btn-primary'
                ng-disabled="!formHolder.editProjectForm.$dirty || formHolder.editProjectForm.$invalid">
            ${message(code: 'is.button.update')}
        </button>
    </div>
</form>
</script>
