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
				templateUrl: 'partials/my.html',
				controller: 'LinkMyCtrl'
			}).
			when('/signup', {
				templateUrl: 'partials/signup.html',
				controller: 'LinkSignUpCtrl'
			}).
			when('/signin', {
				templateUrl: 'partials/signin.html',
				controller: 'LinkSignInCtrl'
			}).
			when('/link/:linkID', {
				templateUrl: 'partials/link-detail.html',
				controller: 'LinkDetailCtrl'
			}).
			otherwise({
				redirectTo: '/'
			});
	}]);
