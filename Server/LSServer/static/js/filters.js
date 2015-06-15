'use strict';

var linkFilters = angular.module('linkFilters',[])

linkFilters.filter('formatTimeStamp',function(){
	return function(input){
		if(input == 0){
			return '';
		}
		var date = new Date(input * 1000);
		return date.toLocaleDateString();
	};
});