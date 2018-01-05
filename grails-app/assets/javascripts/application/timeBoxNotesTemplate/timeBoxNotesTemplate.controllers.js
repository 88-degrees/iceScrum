/*
 * Copyright (c) 2017 Kagilum SAS.
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
 * Colin Bontemps (cbontemps@kagilum.com)
 *
 */

controllers.controller('timeBoxNotesCtrl', ['$scope', '$uibModal', 'TimeBoxNotesTemplateService', function($scope, $uibModal, TimeBoxNotesTemplateService) {
    var ctrl = this;
    // Functions
    $scope.computeTimeBoxNotes = function() {
        if ($scope.timeBoxClass == 'release') {
            TimeBoxNotesTemplateService.getReleaseNotes($scope.release, ctrl.template).then(function(timeBoxNotes) {
                $scope.timeBoxNotes = timeBoxNotes;
            });
        } else if ($scope.timeBoxClass == 'sprint') {
            TimeBoxNotesTemplateService.getSprintNotes($scope.sprint, ctrl.template).then(function(timeBoxNotes) {
                $scope.timeBoxNotes = timeBoxNotes;
            });
        }
    };
    $scope.showEditTemplateModal = function(template) {
        $uibModal.open({
            templateUrl: 'timeBoxNotesTemplate.edit.html',
            controller: 'timeBoxNotesTemplateEditCtrl',
            resolve: {project: $scope.project, template: template}
        }).result.then(
            function() {
                $scope.refreshTimeBoxNotesTemplates();
            }
        );
    };
    $scope.showNewTemplateModal = function() {
        $uibModal.open({
            templateUrl: 'timeBoxNotesTemplate.new.html',
            controller: 'timeBoxNotesTemplateNewCtrl',
            resolve: {project: $scope.project}
        }).result.then(
            function(newTemplate) {
                if (typeof newTemplate != 'undefined') {
                    ctrl.template = _.find($scope.templates, ['id', newTemplate.id]);
                    $scope.computeTimeBoxNotes();
                }
            }
        );
    };
    $scope.refreshTimeBoxNotesTemplates = function() {
        $scope.templates = $scope.project.timeBoxNotesTemplates;
        // auto-select first in list
        if ($scope.templates.length > 0) {
            if ((typeof ctrl.template == 'undefined') || (ctrl.template == {}) || (typeof _.find($scope.templates, ['id', ctrl.template.id]) == 'undefined')) {
                // template undefined or not in template list -> auto-select first in list
                ctrl.template = $scope.templates[0];
            }
            $scope.computeTimeBoxNotes();
        } else {
            delete ctrl.template;
            $scope.timeBoxNotes = "";
        }
    };
    // Init
    $scope.timeBoxClass = $scope.selected.class.toLowerCase();
    $scope.refreshTimeBoxNotesTemplates();
    $scope.project = $scope.getProjectFromState();
}]);

controllers.controller('timeBoxNotesTemplateCtrl', ['$scope', 'ContextService', function($scope, ContextService) {
    // Functions
    $scope.retrieveTags = function() {
        if (_.isEmpty($scope.tags)) {
            ContextService.getTags().then(function(tags) {
                $scope.tags = tags;
            });
        }
    };
    $scope.deleteSection = function(timeBoxNotesTemplate, config) {
        _.pull(timeBoxNotesTemplate.configs, config);
    };
    $scope.addSection = function(timeBoxNotesTemplate) {
        if (typeof timeBoxNotesTemplate.configs == 'undefined') {
            timeBoxNotesTemplate.configs = [];
            $scope.collapseSectionStatus = [];
        }
        // Collapse other sections
        for (var i = 0; i < $scope.collapseSectionStatus.length; i++) {
            $scope.collapseSectionStatus[i] = true;
        }
        // Expand new section
        $scope.collapseSectionStatus[timeBoxNotesTemplate.configs.length] = false;
        timeBoxNotesTemplate.configs.push({storyTags: []});
    };
    $scope.expandSection = function(index) {
        for (var i = 0; i < $scope.collapseSectionStatus.length; i++) {
            if (i == index) {
                $scope.collapseSectionStatus[i] = !$scope.collapseSectionStatus[i];
            } else {
                $scope.collapseSectionStatus[i] = true;
            }
        }
    };
}]);

controllers.controller('timeBoxNotesTemplateEditCtrl', ['$scope', '$controller', 'TimeBoxNotesTemplateService', 'template', 'project', function($scope, $controller, TimeBoxNotesTemplateService, template, project) {
    $controller('timeBoxNotesTemplateCtrl', {$scope: $scope}); // inherit from timeBoxNotesTemplateCtrl
    // Functions
    $scope.update = function(timeBoxNotesTemplate) {
        TimeBoxNotesTemplateService.update(timeBoxNotesTemplate, project.id).then(function(timeBoxNotesTemplate) {
            _.merge(template, timeBoxNotesTemplate);
            $scope.notifySuccess('todo.is.ui.timeBoxNotesTemplate.updated');
            $scope.$close();
        });
    };
    $scope['delete'] = function(timeBoxNotesTemplate) {
        TimeBoxNotesTemplateService.delete(timeBoxNotesTemplate, project).then(function() {
            $scope.notifySuccess('todo.is.ui.deleted');
            $scope.$close();
        });
    };
    // Init
    $scope.editableTimeBoxNotesTemplate = angular.copy(template);
    $scope.collapseSectionStatus = [];
    _.each($scope.editableTimeBoxNotesTemplate.configs, function(config, index) {
        if (typeof config.storyTags == 'undefined') {
            config.storyTags = [];
        }
        //collapse existing sections by default
        $scope.collapseSectionStatus[index] = true;
    });
    $scope.sectionSortOptions = {};
}]);

controllers.controller('timeBoxNotesTemplateNewCtrl', ['$scope', '$controller', 'TimeBoxNotesTemplateService', 'project', function($scope, $controller, TimeBoxNotesTemplateService, project) {
    $controller('timeBoxNotesTemplateCtrl', {$scope: $scope}); // inherit from timeBoxNotesTemplateCtrl
    // Init
    $scope.timeBoxNotesTemplate = {};
    $scope.addSection($scope.timeBoxNotesTemplate);
    $scope.sectionSortOptions = {};
    // Functions
    $scope.save = function(timeBoxNotesTemplate) {
        TimeBoxNotesTemplateService.save(timeBoxNotesTemplate, project).then(function(returnTemplate) {
            _.merge(timeBoxNotesTemplate, returnTemplate);
            $scope.notifySuccess('todo.is.ui.timeBoxNotesTemplate.saved');
            $scope.$close(timeBoxNotesTemplate);
        });
    };
}]);

