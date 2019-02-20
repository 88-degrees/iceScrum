import org.icescrum.core.support.ApplicationSupport

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
* Nicolas Noullet (nnoullet@kagilum.com)
* Vincent BARRIER (vbarrier@kagilum.com)
* Colin Bontemps (cbontemps@kagilum.com)
*
*/
databaseChangeLog = {
    include file: "changelog-promote.groovy"
    include file: "changelog-7-0-2.groovy"
    include file: "changelog-7-0-6.groovy"
    include file: "changelog-7-1.groovy"
    include file: "changelog-7-1-1.groovy"
    include file: "changelog-7-2.groovy"
    include file: "changelog-7-5.groovy"
    include file: "changelog-7-7.groovy"
    include file: "changelog-7-7-2.groovy"
    include file: "changelog-7-9.groovy"
    include file: "changelog-7-29.groovy"
    include file: "changelog-7-31.groovy"
    include file: "changelog-7-34.groovy"
    if (ApplicationSupport.isMySQLUTF8mb4()) {
        include file: "changelog-utf8mb4.groovy"
    }
}