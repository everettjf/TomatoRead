<div class="item linkpoint">
    <div class="content">
        <i class="send outline icon"></i>
        <a class="userlink" link_id="{{$link->id}}" href="{{$link->url}}" target="_blank">
            {{$link->name}}
        </a>
        <span class="linkmore" style="display:none">
            <i class="edit icon linkedit" link_id="{{$link->id}}" ></i>
            <i class="share alternate icon linkshare" link_id="{{$link->id}}" ></i>
        </span>
    </div>
</div>
