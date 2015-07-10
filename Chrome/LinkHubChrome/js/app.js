/**
 * Created by everettjf on 15/7/10.
 */
'use strict';

var linkApp = angular.module('linkApp',[
    'ngRoute',
    'linkControllers',
    'linkFilters'
]);

linkApp.config(['$routeProvider',
    function($routeProvider) {
        $routeProvider.
            when('/', {
                templateUrl: 'partials/single.html',
                controller: 'LinkSingleCtrl'
            }).
            when('/login', {
                templateUrl: 'partials/login.html',
                controller: 'LinkLoginCtrl'
            }).
            when('/tab', {
                templateUrl: 'partials/tab.html',
                controller: 'LinkTabCtrl'
            }).
            when('/import', {
                templateUrl: 'partials/import.html',
                controller: 'LinkImportCtrl'
            }).
            otherwise({
                redirectTo: '/'
            });
    }]);
