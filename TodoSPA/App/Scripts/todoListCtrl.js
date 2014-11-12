'use strict';
app.controller('TodoListController', ['$scope', '$location', 'TodoListService', function ($scope, $location, TodoListService) {
    $scope.error = "";
    $scope.loadingMsg = "Loading...";
    $scope.TodoList = null;
    $scope.EditingInProgress = false;

    $scope.NewTodo = {
        Owner: "default",
        Description: ""
    };

    $scope.EditInProgressTodo = {
        Description: "",
        ID: 0
    };

    $scope.InitNewTodo = function () {
        $scope.NewTodo = {
            Owner: "default",
            Description: ""
        };
    };

    $scope.EditSwitch = function (todo) {
        todo.edit = !todo.edit;
        if (todo.edit) {
            $scope.EditInProgressTodo.Description = todo.Description;
            $scope.EditInProgressTodo.ID = todo.ID;
            $scope.EditingInProgress = true;
        } else {
            $scope.EditingInProgress = false;
        }
    };

    $scope.Populate = function () {
        TodoListService.getItems().success(function (results) {            
            $scope.TodoList = results;
            $scope.loadingMsg = "";
        }).error(function (err) {
            $scope.error = err;
            $scope.loadingMsg = "";
        })
    };
    $scope.Delete = function (id) {
        TodoListService.deleteItem(id).success(function (results) {
            $scope.loadingMsg = "";
            $scope.Populate();
        }).error(function (err) {
            $scope.error = err;
            $scope.loadingMsg = "";
        })
    };
    $scope.Update = function (todo) {
        TodoListService.putItem($scope.EditInProgressTodo).success(function (results) {
            $scope.loadingMsg = "";
            $scope.Populate();
            $scope.EditSwitch(todo);
        }).error(function (err) {
            $scope.error = err;
            $scope.loadingMsg = "";
        })
    };
    $scope.Add = function () {        
        TodoListService.postItem($scope.NewTodo).success(function (results) {
            $scope.loadingMsg = "";
            $scope.InitNewTodo();
            $scope.Populate();
        }).error(function (err) {
            $scope.error = err;
            $scope.loadingMsg = "";
        })
    };
}]);