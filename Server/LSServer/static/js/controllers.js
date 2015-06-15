'use strict';

var linkControllers = angular.module('linkControllers',[]);


linkControllers.controller('LinkIndexCtrl',['$scope','$http',function($scope,$http){

}]);
linkControllers.controller('LinkSignUpCtrl',['$scope','$http',function($scope,$http){
    //test data
    $scope.inputEmail="everettjf@qq.com";
    $scope.inputPassword="hellohello";
    $scope.confirmPassword="hellohello";
    $scope.signMessage="";
    $scope.signupCode = "";

    $scope.signUp = function(){
        if($scope.signupCode == ""){
            $scope.signMessage="Signup Code is empty.";
            return;
        }

        $http.post('/user/signup',{
            Email:$scope.inputEmail,
            Password:$scope.inputPassword,
            Code:$scope.signupCode
        }).success(function(data){
            $scope.signMessage = "Success";

            window.location.href="/my";
        }).error(function(data,status){
            $scope.signMessage="Error:" + data;
        });
    };
}]);
linkControllers.controller('LinkSignInCtrl',['$scope','$http',function($scope,$http){
    $scope.inputEmail="everettjf@qq.com";
    $scope.inputPassword="hellohello";
    $scope.signMessage="";

    $scope.signIn = function(){
        $http.post('/user/signin',{
            Email:$scope.inputEmail,
            Password:$scope.inputPassword
        }).success(function(data){
            $scope.signMessage = "Success";

            window.location.href="/my";
        }).error(function(data,status){
            $scope.signMessage="Error:" + data;
        });
    };
}]);
linkControllers.controller('LinkMyCtrl',['$scope','$http',function($scope,$http){
    console.log('hello');

    $scope.signinMessage = "";
    $scope.isUserSignin = false;
    var checkSignin = function(){
        $http.get('/user/status')
        .success(function(data){
            $scope.isUserSignin = true;
        }).error(function(data,status){
            $scope.isUserSignin = false;
            $scope.signinMessage = "请登录。";
        });
    };
    checkSignin();

    $scope.links = [];
    $scope.topClickLinks = [];
    $scope.topNeverClickLinks = [];
    $scope.tags = [];

    clearInputBox($scope);

    // just test
    fillInputBoxWithTestData($scope);

    var refresh = function(){
        return $http.get('/link/list/').success(function(data){
            $scope.links = data.Links;
        }).error(function(data,status){
            setMessage($scope,"Error get links : " + data);
            logError(data,status);
        });
    };
    refresh();

    var refreshTopClick = function(){
        return $http.get('/link/listtopclick/',{
            Top:10
        }).success(function(data){
            $scope.topClickLinks = data.Links;
        }).error(function(data,status){
            setMessage($scope,"Error get topclicklinks : " + data);
            logError(data,status);
        });
    };
    refreshTopClick();

    var refreshTopNeverClick = function(){
        return $http.get('/link/listtopneverclick/',{
            Top:10
        }).success(function(data){
            $scope.topNeverClickLinks = data.Links;
        }).error(function(data,status){
            setMessage($scope,"Error get topneverclicklinks : " + data);
            logError(data,status);
        });
    };
    refreshTopNeverClick();

    var refreshTags = function(){
        return $http.get('/link/listtags/')
        .success(function(data){
            $scope.tags = data.Tags;
        }).error(function(data,status){
            setMessage($scope,"Error get tags : " + data);
            logError(data,status);
        });
    };
    refreshTags();

    $scope.processURL = function(){
        console.log("process url");
        var url = $scope.linkURL;
        if(url== ""){
            return;
        }

        $http.post('/util/extracttitletags/',{
            URL:$scope.linkURL
        }).success(function(data){
            console.log(data);

            $scope.linkTitle = data.Title;

            var tagString = "";
            for(var key in data.Tags){
                tagString += data.Tags[key];
                tagString += " ";
            }
            $scope.linkTagString = tagString;

        }).error(function(data,status){
            setMessage($scope,"Error Extract TitleTags:"+data);
        });
    };

    $scope.addLink = function(){
        console.log("new link");
        console.log({
            Title:$scope.linkTitle,
            URL:$scope.linkURL,
            TagString:$scope.linkTagString
        });

        $http.post('/link/new/',{
            Title:$scope.linkTitle,
            URL:$scope.linkURL,
            TagString:$scope.linkTagString
        }).success(function(){
            refresh().then(function(){
                clearInputBox($scope);
            })
            setMessage($scope,"Succeed add link");
        }).error(function(data,status){
            setMessage($scope,"Error add link : " + data);
            logError(data,status);
        });
    };

    $scope.linkClick = function(link){
        console.log('link click');
        console.log(link);

        $http.put('/link/click/',{
            ID:link.ID
        }).success(function(){
            refreshTopClick();
        }).error(function(data,status){
            setMessage("Error click count :"+data)
            logError(data,status);
        });
    };

    $scope.trashLink = function(linkID){
        $http.post('/link/trash',{
            ID:linkID
        }).success(function(){
            refreshGroups();
            refresh();
            refreshTopClick();
        }).error(function(data,status){
            setMessage("Error delete link :"+link.Name);
            logError(data,status);
        });
    }

    $scope.comparatorLike = function(actural,expected){
        var tags = expected.split(" ");
        if(tags.length == 0){
            return true;
        }

        if(typeof(actural) != "string"){
            return false;
        }

        for (var index in tags){
            var tag = tags[index]

            var i = actural.indexOf(tag)
            if(i != -1){
                return true;
            }
        }
        return false;
    };

    // group
    $scope.groupMessage = "";
    $scope.groupName = "";
    $scope.groupID = 0;
    $scope.groups = [];
    var refreshGroups = function(){
        return $http.get('/link/listgroup/')
        .success(function(data){
            $scope.groups = data.Groups;
        }).error(function(data,status){
            setMessage($scope,"Error get tags : " + data);
            logError(data,status);
        });
    };
    refreshGroups();

    $scope.addGroup = function(){
        if($scope.groupName == ""){
            $scope.groupMessage = "Group Name can not be empty.";
            return;
        }
        $http.post('/link/addgroup',{
            Name:$scope.groupName
        }).success(function(){
            $scope.groupMessage = "Add Group Succeed";
            $scope.groupName = "";
            refreshGroups();
        }).error(function(data,status){
            $scope.groupMessage = "Add Group Error:" + data;
        });
    };
    $scope.removeGroup = function(groupID){
        if(groupID == 0){
            $scope.groupMessage = "Group ID can not be 0.";
            return;
        }

        $http.post('/link/removegroup',{
            ID:groupID
        }).success(function(){
            $scope.groupMessage = "Remove Group Succeed";

            refreshGroups();
            refreshBasicGroups();
        }).error(function(data,status){
            $scope.groupMessage = "Remove Group Failed";
        });
    };

    $scope.linkDetailMessage = "";
    $scope.linkDetailID = 0;
    $scope.linkDetailAllGroups = [];

    var refreshBasicGroups = function(){
        return $http.get('/link/listgroupbasic/')
        .success(function(data){
            $scope.linkDetailAllGroups = data.Groups;
        }).error(function(data,status){
            setMessage($scope,"Error get tags : " + data);
            logError(data,status);
        });
    };
    refreshBasicGroups();

    $scope.linkMoreClick = function(link){
        $scope.linkDetailTitle = link.Basic.Title;
        $scope.linkDetailURL = link.Basic.URL;

        $http.get('/link/info/' + link.ID)
        .success(function(data){
            $scope.linkDetailID = data.ID;
            $scope.linkDetailTitle = data.Basic.Title;
            $scope.linkDetailURL = data.Basic.URL;

            var tagString = "";
            for (var index in data.Extend.Tags){
                var tag = data.Extend.Tags[index];
                tagString += tag + " ";
            }

            $scope.linkDetailTags = tagString;
            $scope.linkDetailCreateTime = data.Extend.CreateTime;
            $scope.linkDetailClickCount = data.Data.ClickCount;
            $scope.linkDetailLastClickTime = data.Data.LastClickTime;

            refreshBasicGroups();
        }).error(function(data,status){

            $scope.linkDetailMessage = "error";
        });

        $('#linkMoreModal').modal('show')
    };

    $scope.addLinkToGroup = function(groupID,linkID){
        $http.post('/link/addlinktogroup',{
            GroupID:groupID,
            LinkID:linkID
        }).success(function(data){
            refreshGroups();
            console.log("success add link to group");
        }).error(function(data,status){
            console.log("add link to group error :" + data);
        });
    };
    $scope.removeLinkFromGroup = function(linkID){
        $http.post('/link/removelinkfromgroup',{
            LinkID:linkID
        }).success(function(data){
            refreshGroups();
        }).error(function(data,status){
            console.log("remove link from group error :" + data);
        });
    };
}]);

linkControllers.controller('LinkDetailCtrl', ['$scope', '$routeParams','$http',
    function($scope, $routeParams,$http) {
    $scope.linkID = $routeParams.linkID;
}]);

//////////////////////////////////////////
var logError = function(data,status){
    console.log('code' + status + ':' + data);
};

var setMessage = function($scope,data){
    $scope.linkMessage = data;
}

var fillInputBoxWithTestData = function($scope){
    $scope.linkTitle='';
    $scope.linkURL='http://www.baidu.com/';
    $scope.linkTagString = '';
}

var clearInputBox = function($scope){
    $scope.linkTitle = '';
    $scope.linkURL = '';
    $scope.linkTagString = '';
}