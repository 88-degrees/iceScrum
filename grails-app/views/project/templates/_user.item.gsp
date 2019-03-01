<script type="text/ng-template" id="user.item.project.html">
<div class="user">
    <img ng-src="{{ user | userAvatar }}" height="24" width="24" class="rounded-circle user-role" title="{{ user.username }}">
    <span title="{{ user.username + ' (' + user.email + ')' }}" class="name">
        {{ user | userFullName }}
        <small ng-if="!user.id" title="${message(code: 'is.ui.user.will.be.invited')}"><i class="fa fa-envelope text-muted"></i></small>
    </span>
    <a class="btn btn-danger btn-sm btn-model"
       ng-model="foo" %{-- Hack to make form dirty --}%
       ng-if="projectMembersEditable(project)"
       ng-click="removeUser(user, role);">
        <i class="fa fa-close"></i>
    </a>
</div>
</script>
<script type="text/ng-template" id="user.item.portfolio.html">
<div class="user">
    <img ng-src="{{ user | userAvatar }}" height="24" width="24" class="rounded-circle user-role" title="{{ user.username }}">
    <span title="{{ user.username + ' (' + user.email + ')' }}" class="name">
        {{ user | userFullName }}
        <small ng-if="!user.id" title="${message(code: 'is.ui.user.will.be.invited')}"><i class="fa fa-envelope text-muted"></i></small>
    </span>
    <a class="btn btn-danger btn-sm btn-model"
       ng-model="foo" %{-- Hack to make form dirty --}%
       ng-if="portfolioMembersEditable(portfolio) && portfolioMembersDeletable(portfolio, role)"
       ng-click="removeUser(user, role);">
        <i class="fa fa-close"></i>
    </a>
</div>
</script>