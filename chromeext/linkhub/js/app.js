/**
 * Created by everettjf on 10/22/15.
 */

var linkhubApp = angular.module('linkhubApp',[]);

linkhubApp.controller('linkhubCtrl',function($scope){
    console.log('controller');


});

function linkhubScope(){
    return angular.element(document.getElementById('linkhubScopePot')).scope();
}

document.addEventListener('DOMContentLoaded', function() {
    console.log('dom loaded');

    var queryInfo = {
        active:true,
        currentWindow:true
    };

    chrome.tabs.query(queryInfo, function(tabs){
        var tab = tabs[0];

        console.log('active tab got');

        var $scope = linkhubScope();
        $scope.linkTitle = tab.title;
        $scope.linkUrl = tab.url;
        $scope.linkFavicon = tab.favIconUrl;
        $scope.$apply();

    });
});



