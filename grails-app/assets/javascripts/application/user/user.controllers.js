/*
 * Copyright (c) 2015 Kagilum SAS.
 *
 * This file is part of iceScrum.
 *
 * iceScrum is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License.
 *
 * iceScrum is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with iceScrum.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Authors:
 *
 * Vincent Barrier (vbarrier@kagilum.com)
 * Nicolas Noullet (nnoullet@kagilum.com)
 *
 */
controllers.controller('userCtrl', ['$scope', '$timeout', 'UserService', 'User', 'Session', function($scope, $timeout, UserService, User, Session) {
    // Functions
    $scope.update = function(user) {
        var newEmailsSettings = _.mapValues($scope.emailsSettings, function(emailsSetting) {
            return _.keys(_.pickBy(emailsSetting, _.id));
        });
        user.preferences.emailsSettings = newEmailsSettings;
        var languageChanged = Session.user.preferences.language != user.preferences.language;
        var colorSchemeChanged = Session.user.preferences.colorScheme != user.preferences.colorScheme;
        UserService.update(user).then(function(updatedUser) {
            if ($scope.$close) {
                $scope.$close(); // Close auth modal if present
            }
            if (languageChanged || colorSchemeChanged) {
                $scope.notifySuccess('todo.is.ui.profile.updated.refreshing');
                $timeout(function() {
                    document.location.reload(true);
                }, 2000);
            } else {
                $scope.notifySuccess('todo.is.ui.profile.updated');
            }
            angular.extend(Session.user, updatedUser);
            angular.extend(Session.user.preferences, user.preferences); // Need manual setting because it is not returned by the JSON marshaller for performance and security reasons
            Session.user.preferences.emailsSettings = newEmailsSettings;
        });
    };
    $scope.refreshAvatar = function(user) {
        var url;
        var avatar = user.avatar;
        var avatarImg = angular.element('.user-avatars').find('img');
        if (avatar == 'gravatar') {
            url = user.email ? "https://secure.gravatar.com/avatar/" + $.md5(user.email) : null;
        } else if (avatar == 'custom') {
            avatarImg.triggerHandler('click');
            url = null;
        } else {
            url = avatar;
        }
        avatarImg.attr('src', url);
    };
    // Init
    $scope.formHolder = {};
    $scope.editableUser = angular.copy(Session.user);
    $scope.emailsSettings = _.transform(['autoFollow', 'onStory', 'onUrgentTask'], function(emailsSettings, settingName) {
        var projectKeys = $scope.editableUser.preferences.emailsSettings[settingName];
        emailsSettings[settingName] = _.zipObject(projectKeys, _.map(projectKeys, _.constant(true)));
    }, {});
    $scope.languages = {};
    $scope.languageKeys = [];
    Session.getLanguages().then(function(languages) {
        $scope.languages = languages;
        $scope.languageKeys = _.keys(languages);
    });
    $scope.colorSchemes = {
        'dark': $scope.message('is.ui.colorScheme.dark'),
        'light': $scope.message('is.ui.colorScheme.light'),
        'null': $scope.message('is.ui.colorScheme.default')
    };
    $scope.colorSchemeKeys = _.keys($scope.colorSchemes);
}]);

controllers.controller('userInvitationCtrl', ['$scope', '$state', '$timeout', '$location', '$filter', 'UserService', 'Session', function($scope, $state, $timeout, $location, $filter, UserService, Session) {
    // Functions
    $scope.acceptInvitations = function() {
        UserService.acceptInvitations($scope.token).then(function() {
            document.location = $scope.serverUrl;
        })
    };
    $scope.register = function() {
        var user = $filter('userNamesFromEmail')($scope.invitedEmailAddress);
        user.token = $scope.token;
        $scope.$close(true);
        $scope.showRegisterModal(user);
    };
    // Init
    $scope.token = $state.params.token;
    if (Session.authenticated()) {
        $scope.currentEmailAddress = Session.user.email;
    }
    UserService.getInvitations($scope.token).then(function(invitations) {
        if ($location.search().accept === 'true') {
            UserService.acceptInvitations($scope.token).then(function() {
                $scope.application.submitting = true;
                $timeout(function() {
                    document.location = $scope.serverUrl;
                }, 2000);
            })
        } else {
            $scope.invitationEntries = _.map(invitations, function(invitation) {
                var type = invitation.type.name;
                var object;
                if (type === 'PROJECT') {
                    object = invitation.project;
                } else if (type === 'PORTFOLIO') {
                    object = invitation.portfolio;
                } else if (type === 'TEAM') {
                    object = invitation.team;
                }
                return {
                    type: $scope.message('is.' + type.toLowerCase()),
                    objectName: object.name
                };
            });
            $scope.invitedEmailAddress = _.first(invitations).email;
        }
    }, function() {
        $timeout($scope.$close, 3000);
    });
}]);