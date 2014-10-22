'use strict';
app.factory('TodoListService', ['$http', function ($http) {
    var serviceFactory = {};

    var _getItems = function () {
        return $http.get('/api/TodoList');
    };

    var _getItem = function (id) {
        return $http.get('/api/TodoList/' + id);
    };

    var _postItem = function (data) {
        return $http.post('/api/TodoList/',data);
    };

    var _putItem = function (data) {
        return $http.put('/api/TodoList/', data);
    };

    var _deleteItem = function (id) {
        return $http({
            method: 'DELETE',
            url: '/api/TodoList/' + id
        });
    };

    serviceFactory.getItems = _getItems;
    serviceFactory.getItem = _getItem;
    serviceFactory.deleteItem = _deleteItem;
    serviceFactory.postItem = _postItem;
    serviceFactory.putItem = _putItem;

    return serviceFactory;

}]);