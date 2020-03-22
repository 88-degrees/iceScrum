/*
 * Copyright (c) 2017 Kagilum SAS
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

class PortfolioUrlMappings {

    static mappings = {
        "/f/$portfolio/" {
            controller = 'scrumOS'
            action = 'index'
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        // Hook
        "/f/$portfolio/hook" {
            controller = 'hook'
            action = [POST: "save"]
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        "/f/$portfolio/hook/$id" {
            controller = 'hook'
            action = [GET: "show", PUT: "update", DELETE: 'delete', POST: 'update']
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
                id(matches: /\d*/)
            }
        }
        // Tags
        "/f/$portfolio/tag" {
            controller = 'tag'
            action = 'portfolioTag'
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        // Window in portfolio workspace
        "/f/$portfolio/ui/window/$windowDefinitionId" {
            controller = 'window'
            action = 'show'
            constraints {
                windowDefinitionId(matches: /[a-zA-Z]*/)
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        // Window settings in portfolio workspace
        "/f/$portfolio/ui/window/$windowDefinitionId/settings" {
            controller = 'window'
            action = [GET: "settings", POST: "updateSettings"]
            constraints {
                windowDefinitionId(matches: /[a-zA-Z]*/)
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        // Widget in portfolio workspace
        "/f/$portfolio/ui/widget" {
            controller = 'widget'
            action = [GET: "index", POST: "save"]
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        "/f/$portfolio/ui/widget/$widgetDefinitionId/$id?" {
            controller = 'widget'
            action = [GET: "show", POST: "update", DELETE: "delete"]
            constraints {
                widgetDefinitionId(matches: /[a-zA-Z]*/)
                id(matches: /\d*/)
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        "/f/$portfolio/ui/widget/definitions" {
            controller = 'widget'
            action = 'definitions'
            constraints {
                portfolio(matches: /[0-9A-Z]*/)
            }
        }
        "/f/$portfolio/clientOauth/$providerId" {
            controller = 'clientOauth'
            action = [GET: 'show', PUT: 'save', POST: 'save', DELETE: 'delete']
            constraints {
                providerId(matches: /[0-9A-Za-z]*/)
            }
        }
    }
}