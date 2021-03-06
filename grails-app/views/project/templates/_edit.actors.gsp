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

<script type="text/ng-template" id="edit.general.actors.html">
<form role='form'
      show-validation
      novalidate
      ng-controller="actorCtrl"
      name="formHolder.actorForm">
    <h4>${message(code: "is.ui.actor.actors")}</h4>
    <p class="form-text">${message(code: 'is.ui.actor.help')}</p>
    <div class="form-group" ng-if="authorizedActor('create') || authorizedActor('update')">
        <label for="actor.name">${message(code: 'is.actor.name')}</label>
        <div class="input-group">
            <input autofocus
                   name="actor.name"
                   ng-required="actor.id"
                   type="text"
                   id="actor.name"
                   class="form-control"
                   placeholder="{{ actor.id ? '' : message('is.ui.actor.noname') }}"
                   ng-model="actor.name"/>
            <span class="input-group-append">
                <button class="btn btn-primary btn-sm"
                        ng-if="!actor.id"
                        ng-disabled="formHolder.actorForm.$invalid || application.submitting"
                        type="submit"
                        ng-click="save(actor)">
                    ${message(code: 'default.button.create.label')}
                </button>
                <button class="btn btn-primary btn-sm"
                        ng-if="actor.id"
                        ng-disabled="!formHolder.actorForm.$dirty || formHolder.actorForm.$invalid || application.submitting"
                        type="submit"
                        ng-click="update(actor)">
                    ${message(code: 'default.button.update.label')}
                </button>
                <button class="btn btn-secondary btn-sm"
                        ng-if="actor.id"
                        type="submit"
                        ng-click="resetActorForm()">
                    ${message(code: 'is.button.cancel')}
                </button>
            </span>
        </div>
    </div>
    <table ng-if="actors.length" class="table table-striped">
        <thead>
            <tr>
                <th></th>
                <th>${message(code: 'todo.is.ui.stories')}</th>
                <th ng-if="authorizedActor('update') || authorizedActor('delete', actor)"></th>
            </tr>
        </thead>
        <tbody>
            <tr ng-repeat="actor in actors | orderBy: 'name'">
                <td>
                    {{ actor.name }}
                </td>
                <td ng-if="actor.stories_count">
                    <a ng-click="$close()" href="{{ actorSearchUrl(actor) }}">{{ actor.stories_count }}</a>
                </td>
                <td ng-if="!actor.stories_count">
                    {{ actor.stories_count }}
                </td>
                <td ng-if="authorizedActor('update') || authorizedActor('delete', actor)">
                    <a class="btn btn-icon btn-sm float-right"
                       ng-if="authorizedActor('update')"
                       ng-click="edit(actor)">
                        <i class="icon icon-edit"></i>
                    </a>
                    <a class="text-danger float-right mr-3"
                       href
                       ng-if="authorizedActor('delete', actor)"
                       delete-button-click="delete(actor)">
                        <i class="fa fa-close"></i>
                    </a>
                </td>
            </tr>
        </tbody>
    </table>
</form>
</script>