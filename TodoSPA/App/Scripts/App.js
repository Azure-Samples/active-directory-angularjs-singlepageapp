'use strict';
var app = angular.module('TodoSPA', ['ngRoute','AdalAngular']);
// version 1
app.config(['$routeProvider', '$httpProvider', 'adalAuthenticationServiceProvider', function ($routeProvider, $httpProvider, adalAuthenticationServiceProvider) {

    $routeProvider.when("/Home", {
        controller: "HomeController",
        templateUrl: "/App/Views/Home.html",
    }).when("/TodoList", {
        controller: "TodoListController",
        templateUrl: "/App/Views/TodoList.html",
        requireADLogin: true,
    }).when("/UserData", {
        controller: "UserDataController",
        templateUrl: "/App/Views/UserData.html",
    }).otherwise({ redirectTo: "/Home" });

    adalAuthenticationServiceProvider.init(
        {
            tenant: '52d4b072-9470-49fb-8721-bc3a1c9912a1',
            clientId: 'e9a5a8b6-8af7-4719-9821-0deef255f68e',
            instance: 'https://login.windows-ppe.net/',
            extraQueryParameter: 'nux=1'
        },
        $httpProvider   // pass http provider to inject request interceptor to attach tokens
        );
   
}]);