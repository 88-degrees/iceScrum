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
--}%
<script type="text/ng-template" id="attachment.list.html">
<div class="drop-zone">
    <h2>${message(code: 'todo.is.ui.drop.here')}</h2>
</div>
<div ng-repeat="attachment in attachmentable.attachments" ng-show="$index < 10 || pref.showMore">
    <hr ng-class="{'mt-0':$first}">
    <div class="attachment media" ng-class="{'mb-3':$last || (attachmentable.attachments.length > 10 && !pref.showMore)}">
        <img ng-src="{{attachment.ext }}"
             width="27px"
             height="27px"
             class="align-self-center mr-3"
             alt="{{ attachment.ext }}"/>
        <div class="media-body">
            <div>
                <a target="{{:: attachment.provider ? '_blank' : '' }}"
                   ng-show="!isPreviewable(attachment)"
                   href="{{:: getUrl(clazz, attachmentable, attachment) }}">{{ attachment.filename }}</a>
                <a ng-show="isPreviewable(attachment)"
                   href
                   ng-click="showPreview(attachment, attachmentable, clazz)">{{ attachment.filename }}</a>
            </div>
        </div>
    </div>
</div>
<div ng-if="attachmentable.attachments.length > 10 && !pref.showMore" class="text-center">
    <span ng-click="showMore()" class="toggle-more">See more</span>
</div>

<table class="table table-striped attachments">
    <tbody>
        <tr ng-repeat="attachment in attachmentable.attachments">
            <td>
                <div class="col-xs-8">
                    <a href
                       ng-if=":: authorizedAttachment('update', attachment)"
                       style="margin-top: 2px; vertical-align: top;"
                       class="small"
                       ng-click="showEditAttachmentName(attachment, attachmentable)">(${message(code: 'todo.is.ui.attachment.edit')})</a>
                    <div><small ng-if=":: attachment.length > 0">{{:: attachment.length | filesize }}</small> <small>{{ getAttachmentProviderName(attachment) }}</small></div>
                </div>
                <div class="col-xs-4 text-right">
                    <div class="btn-group">
                        <a ng-if=":: isAttachmentEditable(attachment)"
                           ng-click=":: editAttachment(attachment, attachmentable, clazz)"
                           defer-tooltip="${message(code: 'is.button.update')}"
                           class="btn btn-secondary btn-sm"><i class="fa fa-pencil"></i></a>
                        <a href="{{:: getUrl(clazz, attachmentable, attachment) }}"
                           ng-if=":: isAttachmentDownloadable(attachment)"
                           defer-tooltip="${message(code: 'todo.is.ui.attachment.download')}"
                           class="btn btn-secondary btn-sm"><i class="fa fa-download"></i></a>
                        <a href="{{:: getUrl(clazz, attachmentable, attachment) }}"
                           ng-if=":: !isAttachmentDownloadable(attachment)"
                           target="_blank"
                           defer-tooltip="${message(code: 'todo.is.ui.attachment.open')}"
                           class="btn btn-secondary btn-sm"><i class="fa fa-external-link"></i></a>
                        <button ng-click="showPreview(attachment, attachmentable, clazz)" type="button"
                                class="btn btn-sm btn-secondary ng-hide" ng-show="isPreviewable(attachment)"
                                defer-tooltip="${message(code: 'todo.is.ui.attachment.preview')}">
                            <i class="fa fa-search"></i>
                        </button>
                        <button ng-if=":: authorizedAttachment('delete', attachment)"
                                ng-click="confirmDelete({ callback: deleteAttachment, args: [attachment, attachmentable] })"
                                defer-tooltip="${message(code: 'default.button.delete.label')}"
                                type="button" class="btn btn-danger btn-sm">
                            <i class="fa fa-close"></i>
                        </button>
                    </div>
                </div>
            </td>
        </tr>
        <tr ng-repeat="file in $flow.files | flowFilesNotCompleted">
            <td>
                <div class="col-sm-8">
                    <div class="filename" title="{{file.name}}"><i class="fa fa-{{ file.name | fileicon }}"></i> {{ file.name }}</div>
                    <div><small>{{ file.size | filesize }}</small></div>
                </div>
                <div class="col-sm-4 text-right">
                    <div class="progress ng-hide" ng-show="!file.paused && file.isUploading()">
                        <div class="progress-bar" role="progressbar" ng-style="{width: (file.sizeUploaded() / file.size * 100) + '%'}">
                            {{file.sizeUploaded() / file.size * 100 | number:0}}%
                        </div>
                    </div>
                    <div class="btn-group">
                        <button class="btn btn-sm btn-warning ng-hide" defer-tooltip="${message(code: 'todo.is.ui.attachment.pause')}" type="button" ng-click="file.pause()" ng-show="!file.paused && file.isUploading()">
                            <i class="fa fa-pause"></i>
                        </button>
                        <button class="btn btn-sm btn-warning ng-hide" defer-tooltip="${message(code: 'todo.is.ui.attachment.resume')}" type="button" ng-click="file.resume()" ng-show="file.paused">
                            <i class="fa fa-play"></i>
                        </button>
                        <button class="btn btn-sm btn-danger ng-hide" defer-tooltip="${message(code: 'is.button.cancel')}" type="button" ng-click="file.cancel()" ng-show="file.isComplete()">
                            <i class="fa fa-close"></i>
                        </button>
                        <button class="btn btn-sm btn-info ng-hide" defer-tooltip="${message(code: 'todo.is.ui.attachment.retry')}" type="button" ng-click="file.retry()" ng-show="file.error">
                            <i class="fa fa-refresh"></i>
                        </button>
                    </div>
                </div>
            </td>
        </tr>
        <tr ng-show="attachmentable.attachments !== undefined && attachmentable.attachments.length == 0">
            <td class="empty-content">
                <small>${message(code: 'todo.is.ui.attachment.empty')}</small>
            </td>
        </tr>
    </tbody>
</table>
</script>