
// override global clog
clog = function(content){
    logInfo('app',content);
};

var snowsApp = angular.module('snowsApp',[]);
var snowslink = null;

var currentUser = null;
var currentTabID = null;

snowsApp.controller('snowsCtrl',['$scope','$http',function($scope,$http){
    snowslink = $scope;

    // 0 checking login state
    // 1 did login
    // 2 not login
    $scope.loginState = 0;

    $scope.errorInfo = '';

    $scope.linkName = '';
    $scope.linkUrl = '';
    $scope.linkDescription = '';
    $scope.linkDomain = null;
    $scope.linkAspect = null;
    $scope.linkAngle = null;
    $scope.linkFeed = '';
    $scope.linkFavicon = '';


    $scope.domains = []
    $scope.angles = []
    jsonGet('api/domains/',{}, function(data){
        $scope.domains = data.results;
    }, function () {
        clog('error get domains');
    });

    jsonGet('api/angles/',{}, function (data) {
        $scope.angles = data.results;
    }, function () {
        clog('error get angles');
    });

    $scope.saveLink = function () {
        if($scope.linkDomain == null || $scope.linkAspect == null){
            $scope.errorInfo = 'Please select an category';
            return;
        }

        if($scope.linkName == '' || $scope.linkUrl == ''){
            $scope.errorInfo = 'Name or URL cannot be empty';
            return;
        }

        var angle_id = null;
        if($scope.linkAngle != null){
            angle_id = $scope.linkAngle.id;
        }

        apiSaveLink({
            name:$scope.linkName,
            url:$scope.linkUrl,
            aspect_id:$scope.linkAspect.id,
            angle_id:angle_id,
            description:$scope.linkDescription,
            favicon:$scope.linkFavicon,
            feedurl:$scope.linkFeed,
        }, function (result) {
            chromeIconOn();
            window.close();
        },function(){
            $scope.errorInfo = 'Failed to save';
        });
    };

    $scope.removeLink = function(){
        jsonPost('api/bookmark_remove/',{
                url:$scope.linkUrl
            },function(result){
                chromeIconOff();
                window.close();
            },function(){
                $scope.errorInfo = 'Failed to remove';
            });
    };

    $scope.selectAspect = function(domain,aspect){
        $scope.linkDomain = domain;
        $scope.linkAspect = aspect;
    };
    $scope.selectAngle = function(angle){
        $scope.linkAngle = angle;
    };

    $scope.onKeyDown = function(e) {
        var keycode = window.event?e.keyCode:e.which;
        clog('keycode = ' + keycode);
        if(keycode==13) {
            $scope.saveLink();
        }
    };

    $scope.openNewTab = function (relativeUrl) {
        chrome.tabs.create({
            url:serverUrl(relativeUrl)
        },function(tab){
        });
    };
    $scope.openBaseSite = function (){
        chrome.tabs.create({
            url:baseURL
        },function(tab){
        });
    }
    $scope.openNewSite = function (siteUrl) {
        chrome.tabs.create({
            url:siteUrl
        },function(tab){
        });
    };
}]);


function initPageInfo(){
    var queryInfo = {
        active:true,
        currentWindow:true
    };

    chrome.tabs.query(queryInfo, function(tabs){
        clog('active tab got');
        var tab = tabs[0];
        currentTabID = tab.id;

        // Update UI
        snowslink.linkName = tab.title;
        snowslink.linkUrl = tab.url;
        snowslink.linkFavicon = tab.favIconUrl;
        snowslink.$apply();

        // Check login state
        apiCurrentUser(function(user){
            currentUser = user;

            clog('succeed=' + user.name);

            snowslink.loginState = 1;
            snowslink.$apply();

            apiLinkInfo({
                url:tab.url
            },function(result){
                if(result.existed){
                    clog('url is exist:' + result.id);

                    jsonGet('api/bookmarks/' + result.id + '/',{},function(result){
                        snowslink.linkName = result.name;
                        snowslink.linkDescription = result.description;
                        snowslink.linkFavicon = result.favicon;
                        snowslink.linkFeed = result.feed_url;

                        snowslink.linkDomain = result.aspect.domain;
                        snowslink.linkAspect = result.aspect;
                        snowslink.linkAngle = result.angle;

                        snowslink.$apply();

                        angular.element('#title').focus();
                        angular.element('#title').select();

                    }, function(){
                        clog('error get bookmark detail');
                    });
                }else{
                    clog('url not existed : ' + tab.url);
                }
            },function(){
                // Error
            });

        }, function () {
            clog('fail check login');
            snowslink.loginState = 2;
            snowslink.$apply();

            angular.element('#trylogin').focus();

            currentUser = null;
        });
    });
}

document.addEventListener('DOMContentLoaded', function() {
    clog('dom loaded');

    initPageInfo();
});



