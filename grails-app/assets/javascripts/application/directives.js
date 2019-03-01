/*
 * Copyright (c) 2014 Kagilum SAS.
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
var directives = angular.module('directives', []);
directives.directive('isMarkitup', ['$http', '$rootScope', function($http, $rootScope) {
    return {
        restrict: 'A',
        scope: {
            show: '=ngShow',
            html: '=isModelHtml',
            model: '=ngModel'
        },
        link: function(scope, element) {
            var settings = $.extend({
                    resizeHandle: false,
                    scrollContainer: '#main-content .details:first',
                    afterInsert: function() {
                        element.triggerHandler('input');
                    }
                },
                textileSettings);
            var markitup = element.markItUp(settings);
            var container = markitup.parents('.markItUp');
            container.hide();

            scope.$watch('show', function(value) {
                if (value === true) {
                    container.show();
                    setTimeout(function() {
                        element[0].focus();
                    }, 50);
                } else {
                    container.hide();
                }
            });
            element.bind('blur', function() {
                var val = element.val();
                scope.$apply($http({
                    method: 'POST',
                    isBackground: true, // Custom attribute to prevent application.submitting
                    url: $rootScope.serverUrl + '/textileParser',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'},
                    data: 'data=' + encodeURIComponent(val)
                }).success(function(data) {
                    scope.html = data;
                }));
            });
        }
    };
}]).directive('showValidation', ['$compile', '$interpolate', '$rootScope', function($compile, $interpolate, $rootScope) {
    return {
        restrict: "A",
        link: function(scope, element, attrs) {
            scope.$watch(function() {
                return scope.$eval(attrs.name);
            }, function(form) {
                if (form == undefined) {
                    return;
                }
                var inputs = element.find('input[ng-model]:not([validation-watched]):not(.ui-select-search), textarea[ng-model]:not([validation-watched])');
                angular.forEach(inputs, function(it) {
                    var input = angular.element(it);
                    input.attr('validation-watched', '');
                    var container = input.parent();
                    if (container.hasClass('input-group')) {
                        container = container.parent();
                    }
                    var inputName = $interpolate(input.attr('name'))(input.scope());
                    var inputModel = form[inputName];
                    scope.$watch(function() {
                        return inputModel.$invalid && (inputModel.$dirty || inputModel.$touched);
                    }, function(newIsInvalid, oldIsInvalid) {
                        if (newIsInvalid && !oldIsInvalid) {
                            var childScope = scope.$new();
                            childScope.inputModel = inputModel;
                            childScope.errorMessages = function(errors) {
                                return _.transform(errors, function(errorMessages, value, key) {
                                    if (value) {
                                        var errorMessage = $rootScope.message('default.invalid.message');
                                        if (key == 'required') {
                                            errorMessage = $rootScope.message('default.blank.message');
                                        } else if (key == 'min') {
                                            errorMessage = $rootScope.message('default.invalid.min.message', ['', '', '', input.attr(key)]);
                                        } else if (key == 'max') {
                                            errorMessage = $rootScope.message('default.invalid.max.message', ['', '', '', input.attr(key)]);
                                        } else if (key == 'minlength') {
                                            errorMessage = $rootScope.message('default.invalid.min.size.message', ['', '', '', input.attr('ng-' + key)]);
                                        } else if (key == 'maxlength') {
                                            errorMessage = $rootScope.message('default.invalid.max.size.message', ['', '', '', input.attr('ng-' + key)]);
                                        } else if (key == 'pattern') {
                                            errorMessage = input.attr('pattern-error-message') ? input.attr('pattern-error-message') : $rootScope.message('default.doesnt.match.message', ['', '', '', input.attr('ng-' + key)]);
                                        } else if (key == 'url') {
                                            errorMessage = $rootScope.message('default.invalid.url.message');
                                        } else if (key == 'email') {
                                            errorMessage = $rootScope.message('default.invalid.email.message');
                                        } else if (key == 'number') {
                                            errorMessage = $rootScope.message('typeMismatch.java.lang.Integer');
                                        } else if (key == 'isMatch') {
                                            errorMessage = $rootScope.message('is.user.password.check');
                                        } else if (key == 'unique') {
                                            errorMessage = $rootScope.message('default.unique.message');
                                        } else if (key == 'ngRemoteValidate') {
                                            errorMessage = $rootScope.message(input.attr('ng-remote-validate-code'), [value])
                                        } else if (key == 'customValidate') {
                                            errorMessage = $rootScope.message(input.attr('custom-validate-code'), [value])
                                        }
                                        errorMessages.push(errorMessage);
                                    }
                                }, []);
                            };
                            childScope.input = input;
                            container.addClass('has-error');
                            var template = '<div class="form-text bg-danger spaced-form-text"><span ng-repeat="errorMessage in errorMessages(inputModel.$error)">{{ errorMessage }}</span></div>';
                            var compiledTemplate = angular.element($compile(template)(childScope));
                            container.append(compiledTemplate);
                        } else if (!newIsInvalid && oldIsInvalid) {
                            container.removeClass('has-error');
                            container.find('.form-text').remove();
                        }
                    });
                });
            }, true);
        }
    }
}]).directive('notMatch', function() {
    return {
        require: 'ngModel',
        restrict: 'A',
        scope: {
            notMatch: '='
        },
        link: function(scope, element, attrs, modelCtrl) {
            modelCtrl.$validators.notMatch = function(modelValue, viewValue) {
                var value = modelValue || viewValue;
                var notMatch = scope.notMatch;
                return value != notMatch;
            };
            scope.$watch('notMatch', function() {
                modelCtrl.$validate();
            });
        }
    };
}).directive('isMatch', function() {
    return {
        require: 'ngModel',
        restrict: 'A',
        scope: {
            isMatch: '='
        },
        link: function(scope, element, attrs, modelCtrl) {
            modelCtrl.$validators.isMatch = function(modelValue, viewValue) {
                var value = modelValue || viewValue;
                var isMatch = scope.isMatch;
                return value === isMatch;
            };
            scope.$watch('isMatch', function() {
                modelCtrl.$validate();
            });
        }
    };
}).directive('customValidate', [function() {
    return {
        require: 'ngModel',
        restrict: 'A',
        link: function(scope, element, attrs, modelCtrl) {
            modelCtrl.$validators.customValidate = function(modelValue) {
                // Don't use isolated scope to avoid conflicts
                var customValidateItem = scope.$eval(attrs.customValidateItem);
                var customValidate = scope.$eval(attrs.customValidate);
                if (customValidateItem) {
                    return customValidate(modelValue, customValidateItem);
                } else {
                    return customValidate(modelValue)
                }
            };
        }
    };
}]).directive('formAutofillFix', ['$timeout', function($timeout) {
    return function(scope, element, attrs) {
        element.prop('method', 'post');
        if (attrs.ngSubmit) {
            $timeout(function() {
                element
                    .unbind('submit')
                    .bind('submit', function(event) {
                        event.preventDefault();
                        element
                            .find('input, textarea, select')
                            .trigger('input')
                            .trigger('change')
                            .trigger('keydown');
                        scope.$apply(attrs.ngSubmit);
                    });
            });
        }
    };
}]).directive('timeago', [function() {
    return {
        restrict: 'A',
        link: function(scope, element) {
            element.data('hasTimeago', false);
            scope.$watch("", function() {
                // apply only once
                if (!element.data('hasTimeago')) {
                    element.data('hasTimeago', true);
                    element.timeago();
                }
            });
        }
    };
}]).directive('at', [function() {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            scope.$watch(function() {
                return scope.$eval(attrs.at); // Cannot use isolated scope (e.g. scope { at: '=' } because there is already an isolated scope on the element
            }, function(newOptions) {
                element.one('focus', function() {
                    if (element._atwho) {
                        element.atwho('destroy');
                        element._atwho = null;
                    }
                    _.each(newOptions, function(options) {
                        element.atwho(options);
                    });
                    if (global_at_emoji_config) {
                        element.atwho(global_at_emoji_config);
                    }
                    element._atwho = true;
                });
            }, true);
        }
    };
}]).directive('capitalize', function() {
    return {
        require: 'ngModel',
        link: function(scope, element, attrs, modelCtrl) {
            var capitalize = function(inputValue) {
                if (inputValue == undefined) inputValue = '';
                if (attrs.noSpace) {
                    inputValue = inputValue.replace(/[\s]/g, '');
                }
                var capitalized = inputValue.toUpperCase();
                if (capitalized !== inputValue) {
                    modelCtrl.$setViewValue(capitalized);
                    modelCtrl.$render();
                }
                return capitalized;
            };
            modelCtrl.$parsers.push(capitalize);
            capitalize(scope[attrs.ngModel]);
        }
    };
}).directive('btnModel', function() {
    return {
        restrict: 'C',
        require: 'ngModel',
        link: function(scope, element, attrs, modelCtrl) {
            element.on('mousedown', function() {
                modelCtrl.$setDirty();
                modelCtrl.$setTouched();
            });
        }
    };
}).directive('selectOnFocus', function() {
    return {
        restrict: 'A',
        link: function(scope, element) {
            element.on('focus', function() {
                this.select();
            });
        }
    };
}).directive('isProgress', ['$rootScope', '$timeout', '$http', '$window', function($rootScope, $timeout, $http, $window) {
    return {
        restrict: 'E',
        scope: {
            start: '='
        },
        templateUrl: 'is.progress.html',
        link: function(scope, element, attrs) {
            var status;
            scope.progress = {
                value: -1,
                label: "",
                type: 'primary'
            };
            scope.$watch('start', function(value) {
                stopProgress();
                if (value === true) {
                    $timeout(progress, 500);
                }
            });
            var progress = function() {
                $http({
                    method: "get",
                    url: $rootScope.serverUrl + "/progress?lang=" + ($window.navigator.language.split('-')[0])
                }).then(function(response) {
                    var data = response.data;
                    scope.progress = data;
                    if (!data.error && !data.complete) {
                        status = $timeout(progress, 500);
                    }
                    if (data.error) {
                        scope.progress.type = 'danger';
                    } else if (data.complete) {
                        scope.progress.type = 'success';
                    }
                }, function() {
                    scope.progress.type = 'danger';
                    scope.progress.label = $rootScope.message(attrs.errorMessage ? attrs.errorMessage : 'todo.is.ui.error');
                    scope.progress.value = 100;
                });
            };
            var stopProgress = function() {
                if (angular.isDefined(status)) {
                    $timeout.cancel(status);
                    status = undefined;
                }
            };
            element.on('$destroy', function() {
                stopProgress();
            });
        }
    };
}]).directive('circle', function() {
    var polarToCartesian = function(centerX, centerY, radius, angleInDegrees) {
        var angleInRadians = (angleInDegrees - 90) * Math.PI / 180.0;
        return {
            x: centerX + (radius * Math.cos(angleInRadians)),
            y: centerY + (radius * Math.sin(angleInRadians))
        };
    };
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var coords = attrs.circleCoords.split(',');
            _.each(coords, function(val, index) {
                coords[index] = parseInt(val);
            });
            var end = polarToCartesian(coords[0], coords[1], coords[2], coords[3]);
            scope.$watch(attrs.circle, function(value) {
                var endAngle = 360 * value / 100;
                var start = polarToCartesian(coords[0], coords[1], coords[2], endAngle);
                var arcSweep = endAngle - coords[3] <= 180 ? "0" : "1";
                var d = [
                    "M", start.x, start.y,
                    "A", coords[2], coords[2], 0, arcSweep, 0, end.x, end.y
                ].join(" ");
                element.attr('d', d);
            });
        }
    }
}).directive('inputGroupFixWidth', ['$window', '$timeout', function($window, $timeout) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            var resizer = function() {
                element.css('width', element.parent().parent().width() - attrs.inputGroupFixWidth + 'px');
            };
            var windowElement = angular.element($window);
            windowElement.on('resize.inputGroupFixWidth', _.throttle(resizer, 200));
            scope.$on('$destroy', function() {
                windowElement.off("resize.inputGroupFixWidth");
            });
            $timeout(resizer);
        }
    };
}]).directive('timeline', ['ReleaseService', 'SprintStatesByName', '$timeout', function(ReleaseService, SprintStatesByName, $timeout) {
    return {
        restrict: 'A',
        scope: {
            onSelect: '=',
            timeline: '=',
            selected: '='
        },
        link: function(scope, element) {
            var margin = {top: 0, right: 15, bottom: 15, left: 15},
                elementHeight = element.height(),
                height = elementHeight - margin.top - margin.bottom,
                sprintYMargin = 11, releaseYMargin = 15,
                releaseHeight = height - releaseYMargin * 2,
                x = d3.time.scale(),
                xAxis = d3.svg.axis(),
                y = d3.scale.linear().domain([elementHeight - releaseYMargin, 0 - releaseYMargin]).range([elementHeight, 0]),
                selectedItems = [];
            var rootSvg = d3.select(element[0]).append("svg").attr("height", elementHeight);
            var svg = rootSvg.append("g").attr("transform", "translate(" + margin.left + "," + margin.top + ")");
            var timelineBackground = svg.append("rect").attr("class", "timeline-background").attr("height", elementHeight);
            var xAxisSelector = svg.append("g").attr("class", "x axis").attr('transform', 'translate(0,' + (height - margin.top - margin.bottom) + ')');
            var releases = svg.append("g").attr("class", "releases");
            var sprints = svg.append("g").attr("class", "sprints");
            var sprintTexts = svg.append("g").attr("class", "sprint-texts");
            var brush = d3.svg.brush().x(x).y(y).on("brush", onBrush).on("brushend", onBrushEnd);
            var brushSelector = svg.append("g").attr("class", "brush").call(brush);
            var versions = svg.append("g").attr("class", "versions");
            var today = svg.append("rect").attr("class", "today").attr("height", releaseHeight).attr("width", 1.5);
            var getEffectiveEndDate = function(sprint) { return sprint.state == SprintStatesByName.DONE ? sprint.doneDate : sprint.endDate; };

            // Main rendering
            function render() {
                var _releases = scope.timeline;
                if (!scope.timeline || !scope.timeline.length) return;
                rootSvg.attr("width", element.width());
                var elementWidth = element.width(); // WARNING: element.width must be recomputed after rootSvg.attr("width", ...) because it changes if the right panel has lateral padding (e.g. with .new form which has .card-body padding)
                var width = elementWidth - margin.left - margin.right;
                x.domain([_.head(_releases).startDate, _.last(_releases).endDate]).range([0, width]);
                xAxis.scale(x);
                xAxisSelector.call(xAxis);
                timelineBackground.attr("width", width);

                var _sprints = ReleaseService.findAllSprints(_releases);
                var releaseSelector = releases.selectAll('rect').data(_releases);
                var sprintSelector = sprints.selectAll('rect').data(_sprints);
                var sprintTextsSelector = sprintTexts.selectAll('text').data(_sprints);
                var versionSelector = versions.selectAll('.version').data(_.filter(_sprints, 'deliveredVersion'));
                var versionTriangleSelector = versionSelector.select('path');
                var versionTextSelector = versionSelector.select('text');
                var todaySelector = svg.select('.today').data([new Date()]);
                // Remove
                releaseSelector.exit().remove();
                sprintSelector.exit().remove();
                sprintTextsSelector.exit().remove();
                versionSelector.exit().remove();
                // Insert
                var classByState = {};
                classByState[SprintStatesByName.TODO] = 'todo';
                classByState[SprintStatesByName.IN_PROGRESS] = 'inProgress';
                classByState[SprintStatesByName.DONE] = 'done';
                releaseSelector.enter().append("rect")
                    .attr("y", releaseYMargin)
                    .attr("height", releaseHeight);
                sprintSelector.enter().append("rect")
                    .attr("y", sprintYMargin + releaseYMargin)
                    .attr("height", releaseHeight - sprintYMargin * 2);
                sprintTextsSelector.enter().append("text")
                    .attr("y", 6 + height / 2)
                    .style("text-anchor", "middle")
                    .attr("font-size", "18px");
                var versionEnter = versionSelector.enter().append("g")
                    .attr("class", "version");
                versionEnter.append("path")
                    .attr("d", d3.svg.symbol().type("triangle-down"));
                versionEnter.append("text")
                    .attr("y", 12)
                    .style("text-anchor", "middle")
                    .attr("font-size", "11px");
                // Update
                var getX = function(item) {
                    return x(item.startDate);
                };
                var getWidth = function(item) {
                    return x(item.endDate) - x(item.startDate);
                };
                var selectedClass = function(item) {
                    return _.includes(selectedItems, item) ? ' selected' : ''
                };
                var dateSelectedClass = function(date) {
                    return _.some(selectedItems, function(item) {
                        return item.startDate <= date && item.endDate >= date;
                    }) ? ' selected' : ''
                };
                releaseSelector
                    .attr('x', getX)
                    .attr("width", getWidth)
                    .attr("class", function(release) { return "release release-" + classByState[release.state] + selectedClass(release); });
                sprintSelector
                    .attr('x', getX)
                    .attr("width", getWidth)
                    .attr("class", function(sprint) { return "sprint sprint-" + classByState[sprint.state] + selectedClass(sprint); });
                sprintTextsSelector
                    .text(function(sprint) { return sprint.index; })
                    .attr('x', function(sprint) { return x(new Date(sprint.startDate.getTime() + (sprint.endDate.getTime() - sprint.startDate.getTime()) / 2)); })
                    .attr("class", function(sprint) { return "sprint-text" + selectedClass(sprint); });
                versionSelector
                    .attr("class", function(sprint) { return 'version' + dateSelectedClass(getEffectiveEndDate(sprint)); });
                versionTriangleSelector
                    .attr("transform", function(sprint) { return "translate(" + x(getEffectiveEndDate(sprint)) + "," + (releaseYMargin + sprintYMargin - 5) + ")"; }); // Offset to align border rather than center
                versionTextSelector
                    .text(function(sprint) { return sprint.deliveredVersion; })
                    .attr('x', function(sprint) { return x(getEffectiveEndDate(sprint)); });
                todaySelector
                    .attr("transform", function(date) { return 'translate(' + x(date) + ',' + releaseYMargin + ')'; }); // Offset to align border rather than center
            }

            // Brush management
            function reinitializeBrush() {
                $timeout(function() {
                    brush.clear();
                    brushSelector.call(brush);
                }, 150); // Delay to let the window the time to resize
            }

            function findSprintsOrAReleaseInRange(ranges) {
                var dates = ranges.x;
                var y = ranges.y;
                var onSprint = (y[0] > sprintYMargin || y[1] > sprintYMargin) && (y[0] < (releaseHeight - sprintYMargin) || y[1] < (releaseHeight - sprintYMargin));
                var res;
                if (onSprint) {
                    res = _.filter(sprints.selectAll("rect").data(), function(sprint) {
                        return sprint.startDate <= dates[1] && sprint.endDate >= dates[0];
                    });
                }
                if (!res || !res.length) {
                    res = [_.find(releases.selectAll("rect").data(), function(release) {
                        return release.startDate <= dates[1] && release.endDate >= dates[0];
                    })];
                }
                return res;
            }

            function getBrushRanges() {
                var transposedExtend = _.zip.apply(null, (brush.extent()));
                return {x: _.map(transposedExtend[0], d3.time.day.utc), y: transposedExtend[1]};
            }

            function onBrush() {
                if (!d3.event.sourceEvent) return; // Only transition after input
                selectedItems = findSprintsOrAReleaseInRange(getBrushRanges());
                render(); // To update selected items
            }

            function onBrushEnd() {
                if (!d3.event.sourceEvent) return; // Only transition after input
                selectedItems = findSprintsOrAReleaseInRange(getBrushRanges());
                if (selectedItems.length > 0) {
                    scope.onSelect(selectedItems);
                }
                reinitializeBrush();
                render(); // To update selected items
            }

            // Register render on model change
            var removeTimelineWatcher = scope.$watch('timeline', function() {
                render();
                reinitializeBrush(); // Init brush on first loading or after creating first release
            }, true);
            var removeSelectedWatcher = scope.$watch('selected', function(newSelected) {
                selectedItems = newSelected;
                render(); // To update selected items
            }, true);
            // Register render on width change (either by resize or opening / closing of details view)
            d3.select(window).on('resize', _.throttle(render, 200));
            var unregisterRenderOnDetailsChanged = scope.$root.$on('$viewContentLoaded', function(event, viewConfig) {
                if (viewConfig.indexOf('@planning') != -1) {
                    $timeout(render, 100);
                }
            });
            // Unregister event listener & watchers when state change & scope destroy
            var unregisterRemoveWatchersOnWindowChanged = scope.$on('$stateChangeStart', function(event, toState) {
                if (!_.startsWith(toState.name, 'planning')) {
                    removeTimelineWatcher();
                    removeSelectedWatcher();
                }
            });
            scope.$on('$destroy', function() {
                d3.select(window).on('resize', null);
                unregisterRemoveWatchersOnWindowChanged();
                unregisterRenderOnDetailsChanged();
            });
        }
    }
}]).directive('stickyNoteMenu', ['$compile', '$rootScope', function($compile, $rootScope) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            element.on('mouseover', function() {
                if (!$rootScope.application.dragging) {
                    var newElement = element.clone();
                    newElement.removeAttr('sticky-note-menu');
                    newElement.attr('uib-dropdown', '');
                    newElement.attr('dropdown-append-to-body', '');
                    newElement.html('<a uib-dropdown-toggle><i class="fa fa-ellipsis-h"></i></a><ul uib-dropdown-menu class="dropdown-menu-right" template-url="' + attrs.stickyNoteMenu + '"></ul>');
                    element.replaceWith(angular.element($compile(newElement)(scope)));
                }
            });
        }
    }
}]).directive('stickyNoteColor', ['$filter', '$rootScope', function($filter, $rootScope) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            element.css($filter('createGradientBackground')(attrs.stickyNoteColor ? attrs.stickyNoteColor : '#f9f157'));
        }
    }
}]).directive('deferTooltip', ['$compile', '$rootScope', function($compile, $rootScope) {
    return {
        restrict: 'A',
        transclude: false,
        compile: function(cElement, attr) {
            var cElementContent = cElement.html();
            return function link(scope, element) {
                element.on('mouseover', function() {
                    if (!$rootScope.application.dragging) {
                        var tooltipElement = element.clone();
                        var tooltipContent = tooltipElement.attr('defer-tooltip');
                        tooltipElement.removeAttr('defer-tooltip');
                        tooltipElement.attr('uib-tooltip', tooltipContent);
                        var newScope = scope.$new();
                        if (cElementContent) {
                            tooltipElement.html(cElementContent);
                        }
                        var tooltipCompiled = $compile(tooltipElement)(newScope);
                        element.replaceWith(tooltipCompiled);
                        scope.$digest(); //necessary in case there is ng-* on or inside
                    }
                });
            }
        }
    }
}]).directive('unavailableFeature', ['$uibModal', function($uibModal) {
    return {
        restrict: 'A',
        scope: {
            unavailableFeature: '='
        },
        link: function(scope, element) {
            if (scope.unavailableFeature) {
                element.on('click', function() {
                    $uibModal.open({
                        template: '<div class="modal-header"><h4 class="modal-title">Feature Coming Soon</h4></div><div class="modal-body">This feature is still in development, it will be available soon!</div><div class="modal-footer"><button type="button" class="btn btn-secondary" ng-click="$close()">Close</button></div>',
                        size: 'sm'
                    });
                    return false;
                });
            }
        }
    }
}]).directive('selectable', ['$document', function($document) {
    return {
        restrict: 'A',
        scope: {
            selectable: '='
        },
        link: function(scope, element) {
            // Scroll to selection on refresh
            element.scope().$on('selectable-refresh', function() {
                var scrollableContainerSelector = '.card-body';
                element.find(scrollableContainerSelector).addBack(scrollableContainerSelector).each(function(i, container) {
                    container = $(container);
                    var selectedElements = container.find('.is-selected');
                    if (selectedElements.length > 0) {
                        var anySelectedVisible = _.some(selectedElements, function(selectedElement) {
                            selectedElement = angular.element(selectedElement);
                            var containerTop = 0; // Use relative positions
                            var containerBottom = container.height();
                            var elTop = selectedElement.position().top;
                            var elBottom = elTop + selectedElement.height();
                            return elBottom > containerTop && elBottom < containerBottom || elTop < containerBottom && elTop > containerTop;
                        });
                        if (!anySelectedVisible) {
                            var firstSelected = selectedElements.first();
                            var offset = 45; // Hardcoded offset to compensate card-header & margin, TODO use dynamic offset
                            var currentScroll = container.scrollTop(); // current scroll reduces the firstSelected top position, we must add it back to get the initial position
                            var scrollTop = firstSelected.position().top - offset + currentScroll;
                            // Rely on jquery animate :/
                            container.animate({
                                scrollTop: scrollTop
                            }, 400);
                        }
                    }
                });
            });
            // Selection / deselection on click
            var selectableOptions = scope.selectable;
            var selectedClass = 'is-selected';
            var selectedIdAttr = 'selectable-id';
            var selectedSelector = '[' + selectedIdAttr + '].' + selectedClass;
            var lastSelected;
            // Disable bulk select automatically when nothing is selected
            if (selectableOptions.hasSelected) {
                scope.$watch(selectableOptions.hasSelected, function(newValue) {
                    if (!newValue && !selectableOptions.forceMultiple && selectableOptions.selectingMultiple) {
                        selectableOptions.selectingMultiple = false;
                    }
                });
            }
            element.on('click', function(event) { // Listen only on the container element rather than on each element: allow deselecting and avoid the need to listen to new elements
                var target = angular.element(event.target);
                if (!selectableOptions.notSelectableSelector || target.closest(selectableOptions.notSelectableSelector).length == 0) {
                    $document[0].getSelection().removeAllRanges(); // prevents text-selection when doing shift + click
                    var selectedIds = [];
                    var selectingMultiple = selectableOptions.forceMultiple != undefined ? selectableOptions.forceMultiple : selectableOptions.selectingMultiple;
                    if (!selectableOptions.allowMultiple || (!event.ctrlKey && !event.metaKey && !event.shiftKey && !selectingMultiple)) {
                        element.find(selectedSelector).removeClass(selectedClass);
                    }
                    var selectableElement = target.closest('[' + selectedIdAttr + ']');
                    if (selectableElement.length != 0) {
                        if (lastSelected && event.shiftKey && selectableOptions.allowMultiple) { // Dark magic to emulate shift+click behavior observed in OS
                            var elementsBetween = function(el1, el2) {
                                var elements = el1.parent().children('[' + selectedIdAttr + ']');
                                var index1 = elements.index(el1);
                                var index2 = elements.index(el2);
                                var slice = [];
                                if (index1 != -1 && index2 != -1 && index1 != index2) {
                                    var sortedIndexes = _.sortBy([index1, index2]);
                                    slice = elements.slice(sortedIndexes[0], sortedIndexes[1] + 1);
                                }
                                return slice;
                            };
                            var selectedElementsNextTo = function(el) {
                                var notSelectedSelector = '[' + selectedIdAttr + ']:not(.' + selectedClass + ')';
                                var before = el.prevUntil(notSelectedSelector);
                                var after = el.nextUntil(notSelectedSelector);
                                return jQuery.merge(before, after);
                            };
                            _.each(selectedElementsNextTo(lastSelected), function(el) {
                                angular.element(el).removeClass(selectedClass);
                            });
                            _.each(elementsBetween(selectableElement, lastSelected), function(el) {
                                el = angular.element(el);
                                if (!el.hasClass(selectedClass)) {
                                    el.addClass(selectedClass);
                                }
                            });
                        } else {
                            selectableElement.toggleClass(selectedClass);
                            lastSelected = selectableElement.hasClass(selectedClass) ? selectableElement : null;
                        }
                        selectedIds = _.map(element.find(selectedSelector), function(selected) {
                            return parseInt(angular.element(selected).attr(selectedIdAttr));
                        });
                    } else {
                        lastSelected = null;
                    }
                    selectableOptions.selectionUpdated(selectedIds);
                }
            });
        }
    }
}]).directive("stickyList", ['$window', function($window) {
    return {
        restrict: 'A',
        link: function(scope, element, attrs) {
            // Functions
            var getHeaders = function() {
                return _.map(element.find('.sticky-header:not(.cloned)'), angular.element);
            };
            var position = function() {
                if (getHeaders().length) {
                    var originOffset = container.offset().top;
                    offset = originOffset;
                    _.each($headerClones, function($clone, index) {
                        offset = originOffset + computeStackOffset(index);
                        $clone.css('top', offset + 'px');
                        if (index < stackSize) {
                            $clone.css('z-index', '98');
                        }
                        computeWidth(index);
                    });
                }
            };
            var computeStackOffset = function(index) {
                var _offset = 0;
                if (stackSize > 0) {
                    _.each($headerClones, function($clone, indexH) {
                        if (indexH < stackSize && index > indexH) {
                            _offset += $clone.outerHeight(true);
                        }
                    });
                }
                return _offset;
            };
            var computeWidth = function(index) {
                var $clone = $headerClones[index];
                var $header = getHeaders()[index];
                $clone.width($header.width());
                var $headerThs = $header.find('th,td');
                var $cloneThs = $clone.find('th,td');
                _.each($headerThs, function(headerTh, index) {
                    angular.element($cloneThs[index]).css('width', angular.element(headerTh).outerWidth());
                });
            };
            var render = function() {
                _.each(getHeaders(), function($header, index) {
                    var isOnTop = container.scrollTop() == 0;
                    if (wasOnTop && !isOnTop) {
                        // Cleanup on top for corner cases where clones remain
                        _.each($headerClones, function(clone) {
                            clone.remove();
                        });
                        $headerClones = [];
                    }
                    wasOnTop = isOnTop;
                    var top = $header.offset().top;
                    var $previousClone;
                    if (index == 0) {
                        position();
                    } else {
                        $previousClone = $headerClones[index - 1];
                    }
                    if (offset > top && container.scrollTop() > 0) {
                        if ($header.css('visibility') != 'hidden') {
                            var $clone = $header.clone();
                            $clone.data('height', $header.outerHeight(true))
                                .css('top', offset + 'px').css('position', 'fixed').css('overflow-y', 'hidden').css('z-index', index + 1)
                                .addClass('cloned').addClass('sticky-' + index);
                            $headerClones.push($clone);
                            $header.parent().css('position', 'relative');
                            $clone.insertAfter($header);
                            computeWidth(index);
                            $header.css('visibility', 'hidden');
                            if ($previousClone && index > stackSize) {
                                $previousClone.css('visibility', 'hidden');
                            }
                        }
                    } else {
                        if ($previousClone && !$previousClone.hasClass('sticky-stack')) {
                            var diff = offset - top + $previousClone.data('height');
                            $previousClone.css('top', (diff >= 0 ? offset - diff : offset) + 'px');
                        }
                        if ($header.css('visibility') == 'hidden') {
                            $headerClones.pop().remove();
                            $header.css('visibility', 'visible');
                            if ($previousClone) {
                                $previousClone.css('height', '').css('visibility', 'visible');
                            }
                        }
                    }
                });
            };
            // Init
            var offset;
            var wasOnTop = true;
            var $headerClones = [];
            var stackSize = element.find('.sticky-header.sticky-stack').length;
            var container = attrs.stickyList ? angular.element(attrs.stickyList) : element;
            container.on("scroll", render); // Destroyed automatically
            var windowElement = angular.element($window);
            var viewElement = angular.element('.main > .view');
            windowElement.on("resize.stickyList", _.throttle(position, 200));
            viewElement.on("scroll", position);
            scope.$on('$destroy', function() {
                windowElement.off("resize.stickyList");
                viewElement.off("scroll", position);
            });
            render();
        }
    };
}]).directive('visualStates', ['$compile', '$filter', function($compile, $filter) {
    return {
        restrict: 'E',
        require: 'ngModel',
        scope: {
            modelStates: '='
        },
        replace: true,
        templateUrl: 'states.html',
        link: function(scope, element, attrs, modelCtrl) {
            scope.$watch(function() { return modelCtrl.$modelValue.state; }, function(newState) {
                var allStates = _.filter(_.toPairs(scope.modelStates), function(pair) {
                    var state = pair[1];
                    return newState < 0 ? state < 0 : state >= 0;
                });
                scope.states = _.map(_.sortBy(allStates, '[1]'), function(pair) {
                    var state = pair[1];
                    var newModel = modelCtrl.$modelValue;
                    var code = attrs.$normalize(pair[0].toLowerCase());
                    var date = newModel[code + 'Date'];
                    var name = $filter('i18n')(state, newModel.class + 'States');
                    return {
                        name: name,
                        width: 100 / allStates.length,
                        completed: newState >= state,
                        current: newState == state,
                        tooltip: name + (date ? ': ' + ($filter('dateTime')(date)) : ''),
                        class: 'color-state-' + code
                    };
                });
            });
        }
    };
}]).directive('shortcutMenu', ['$filter', '$rootScope', function($filter, $rootScope) {
    return {
        restrict: 'E',
        scope: {
            btnSm: '=',
            ngModel: '=',
            viewType: '=',
            modelMenus: '=',
            btnSecondary: '=?'
        },
        replace: true,
        templateUrl: 'button.shortcutMenu.html',
        link: function(scope) {
            scope.message = $rootScope.message;
            scope.btnSecondary = angular.isDefined(scope.btnSecondary) ? scope.btnSecondary : false;
            scope.$watch(function() { return scope.ngModel.lastUpdated; }, function() {
                var i = scope.modelMenus.length;
                scope.sortedMenus = $filter('orderBy')(scope.modelMenus, function(menuElement) {
                    var defaultPriority = i--;
                    return menuElement.priority ? menuElement.priority(scope.ngModel, defaultPriority, scope.viewType) : defaultPriority;
                }, true);
                scope.menuElement = _.find(scope.sortedMenus, function(menuElement) {
                    return menuElement.visible(scope.ngModel, scope.viewType);
                });
            });
        }
    };
}]).directive('detailsLayoutButtons', ['$rootScope', '$state', '$localStorage', function($rootScope, $state, $localStorage) {
    return {
        restrict: 'E',
        scope: {
            removeAncestor: '='
        },
        replace: true,
        templateUrl: 'details.layout.buttons.html',
        link: function(scope) {
            // Functions
            scope.closeDetailsViewUrl = function() {
                var stateName = '^';
                if ($state.includes('**.tab')) {
                    stateName += '.^'
                }
                if (scope.removeAncestor) {
                    _.times(_.isNumber(scope.removeAncestor) ? parseInt(scope.removeAncestor) : 1, function() {
                        stateName += '.^';
                    });
                }
                return $state.href(stateName);
            };
            scope.toggleDetachedDetailsView = function() {
                scope.application.detachedDetailsView = !scope.application.detachedDetailsView;
                if (!scope.application.detachedDetailsView) {
                    scope.application.minimizedDetailsView = false;
                }
                $localStorage['minimizedDetailsView'] = scope.application.minimizedDetailsView;
                $localStorage['detachedDetailsView'] = scope.application.detachedDetailsView;
            };
            scope.toggleMinimizedDetailsView = function() {
                scope.application.minimizedDetailsView = !scope.application.minimizedDetailsView;
                $localStorage['minimizedDetailsView'] = scope.application.minimizedDetailsView;
            };
            // Init
            scope.application = $rootScope.application;
        }
    };
}]).directive('iconBadge', function() { // Be careful, this directive has no watch, it will work only under isWatch
    return {
        restrict: 'E',
        scope: {}, // Required to get an isolated scope
        templateUrl: 'icon.with.badge.html',
        replace: true,
        link: function(scope, element, attrs) {
            scope.max = attrs.max ? scope.$eval(attrs.max) : 9;
            scope.count = scope.$eval(attrs.count);
            if (scope.$eval(attrs.hide) && scope.count <= scope.max) {
                return;
            }
            scope.icon = scope.count === 0 && attrs.iconEmpty ? attrs.iconEmpty : attrs.icon;
            scope.href = attrs.href;
            scope.tooltip = scope.count + ' ' + attrs.tooltip;
            scope.classes = (attrs.classes ? attrs.classes : '') + (scope.count > 0 ? ' active' : '');
            scope.countString = (scope.count > scope.max) ? scope.max + '+' : (scope.count > 0 ? scope.count : '');
        }
    };
}).directive('documentation', ['$rootScope', function($rootScope) {
    return {
        restrict: 'E',
        scope: {
            docUrl: '@',
            title: '@',
            big: '=?'
        },
        replace: true,
        templateUrl: 'documentation.html',
        link: function(scope) {
            scope.message = $rootScope.message;
        }
    };
}]).directive('isWatch', ['$parse', function($parse) {
    'use strict';
    return {
        transclude: true,
        link: function link(scope, $el, attrs, ctrls, transclude) {
            var previousElements;
            var previousScope;
            compile();

            function compile() {
                transclude(scope.$new(false, scope), function(clone, clonedScope) {
                    previousElements = clone;
                    previousScope = clonedScope;
                    $el.append(clone);
                });
            }

            function recompile() {
                if (previousElements) {
                    previousElements.remove();
                    previousElements = null;
                    $el.empty();
                }
                if (previousScope) {
                    previousScope.$destroy();
                }
                compile();
            }

            scope.$watch(attrs.isWatch, function(_new, _old) {
                var useBoolean = attrs.hasOwnProperty('useBoolean');
                if ((useBoolean && (!_new || _new === 'false')) || (!useBoolean && (!_new || _new === _old))) {
                    return;
                }
                if (useBoolean) {
                    $parse(attrs.isWatch).assign(scope, false);
                }
                var useProperty = attrs.hasOwnProperty('isWatchProperty');
                if (useProperty) {
                    var properties = $parse(attrs.isWatchProperty)(scope);
                    if (!(properties instanceof Array)) {
                        properties = [properties]
                    }
                    _.every(properties, function(property) {
                        var tmpOld = _old[property] instanceof Date ? _old[property].getTime() : _old[property];
                        var tmpNew = _new[property] instanceof Date ? _new[property].getTime() : _new[property];
                        if (tmpOld !== tmpNew) {
                            recompile();
                            return false; // Breaks the every so further properties are not evaluated
                        }
                        return true;
                    });
                }
                if (!useProperty) {
                    recompile();
                }
            }, typeof $parse(attrs.isWatch)(scope) === 'object');
        }
    };
}]).directive('suspendable', function() {
    return {
        link: function(scope, element, attrs) {
            var $window = $(window),
                DEBUG = attrs.suspendableDebug === 'true',
                watchersForId = {},
                uniqueSuspendableId = Math.random().toString(32).slice(2),
                trackedEvents = ['scroll.suspendable-' + uniqueSuspendableId, 'resize.suspendable-' + uniqueSuspendableId],
                heartbeat,
                scopeCheckFunc;

            // Attach custom events "suspend" and "resume" to our "suspendable" element
            // Whenever these events get fired, we pass a unique identifier corresponding to
            // the contained ng-scope to suspend/resume. We keep a map of scopeId -> scope.$$watchers
            // Keep these events as raw jQuery, using $rootScope.$on and $rootScope.$emit as an event bus
            // led to additional performance issues
            element.on('suspend', function(event, suspendId, scopeToSuspend) {
                if (!watchersForId[suspendId]) {
                    watchersForId[suspendId] = scopeToSuspend.$$watchers;
                    scopeToSuspend.$$watchers = [];
                }
            }).on('resume', function(event, resumeId, scopeToResume) {
                if (watchersForId[resumeId]) {
                    scopeToResume.$$watchers = watchersForId[resumeId];
                    delete watchersForId[resumeId];
                }
            });

            // If the scope gets destroyed, unbind the listeners we created
            scope.$on('$destroy', function() {
                $window.off(trackedEvents.join(" "));
                element.off('suspend resume');
                clearInterval(heartbeat);
                watchersForId = null;
            });

            scopeCheckFunc = function() {
                var windowOffset = $window.scrollTop(),
                    windowHeight = $window.height(),
                    scopeElems = element.find('.ng-scope, .ng-isolate-scope'),
                    scopes = _.map(scopeElems, function(elem) {
                        return {
                            scope: angular.element(elem).scope(),
                            elem: elem
                        };
                    });

                _.each(scopes, function(obj) {
                    var $elem = $(obj.elem),
                        offset = $elem.offset();

                    if (!$elem.attr('data-scope-id')) {
                        $elem.attr('data-scope-id', _.uniqueId());
                    }

                    // TODO this implementation is naive and there should be finer grained checks around an element's position vs page position
                    var event = (offset.top <= windowOffset || offset.top >= windowOffset + windowHeight || !$elem.is(':visible')) ? 'suspend' : 'resume';

                    if (DEBUG) {
                        if (event === 'suspend') {
                            $elem.css("border-color", 'red');
                        } else if (event === 'resume') {
                            $elem.css("border-color", 'green');
                        }
                    }

                    element.trigger(event, [$elem.attr('data-scope-id'), obj.scope]);
                });
            };

            // Clean up after long/fast scrolls and reattach if hidden elements become visible
            heartbeat = setInterval(scopeCheckFunc, 15000);

            // Attach namespaced scroll and resize events to the window object. Only call the listener every 50ms
            // The listener will find all scopes within the container, attach a unique ID if necessary, and trigger
            // the appropriate event based on window scroll position and element offset.
            $window.on(trackedEvents.join(" "), _.debounce(scopeCheckFunc, 15000));
        }
    };
});