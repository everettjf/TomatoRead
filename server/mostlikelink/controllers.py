# coding=utf-8
from . import models
from flask.ext.login import current_user
from . import utils


class UserController:
    __user = None
    __except_tags = []
    __filter_tags_entities = []

    def __init__(self):
        pass

    def it_is_me(self):
        return current_user.is_authenticated \
               and current_user.id == self.__user.id

    def has_filter_tags(self):
        return len(self.__filter_tags_entities) > 0

    def init_user(self, blog_id):
        self.__user = models.User.objects(blog_id=blog_id
                                          ).first()
        if self.__user is None:
            return False

        # Whether include Private Links
        if not self.it_is_me():
            tag_private = models.Tag.objects(user=self.__user,
                                             name=':PRIVATE'
                                             ).first()
            self.__except_tags.append(tag_private)

        return True

    def init_filter_tags(self, filter_tags):
        filter_tags_ids = [tag['id'] for tag in filter_tags]
        self.__filter_tags_entities = models.Tag.objects(user=self.__user,
                                                  id__in=filter_tags_ids
                                                  )
        print 'filter tags entities len = %d' % len(self.__filter_tags_entities)

    def fetch_top_links(self):
        top_links_list = []
        tag_top = models.Tag.objects(user=self.__user,
                                     name=':TOP'
                                     ).first()
        if tag_top is not None:
            print 'tag top is = %s'% tag_top.name
            top_links = models.LinkPost.objects(user=self.__user,
                                                tags__in=[tag_top],
                                                tags__nin=self.__except_tags
                                                )
            print 'top links len = %d' % len(top_links)

            top_links_list = [dict(
                id=str(link.id),
                title=link.title,
                url=link.url,
                favicon=link.favicon,
            ) for link in top_links]

        return top_links_list

    def fetch_all_tags(self):
        all_tags = models.Tag.objects(user=self.__user)

        all_topics_list = [dict(
            id=str(tag.id),
            name=tag.name
        ) for tag in all_tags if tag.is_topic]

        all_tags_list = [dict(
            id=str(tag.id),
            name=tag.name
        ) for tag in all_tags if not tag.is_topic]

        return all_topics_list, all_tags_list

    def fetch_total_link_count(self):
        return len(models.LinkPost.objects(user=self.__user))

    def fetch_all_links(self):
        all_links = []
        if not self.has_filter_tags():
            all_links = models.LinkPost.objects(user=self.__user,
                                                tags__nin=self.__except_tags
                                                )[0:30]
        else:
            # With filter
            all_links = models.LinkPost.objects(user=self.__user,
                                                tags__all=self.__filter_tags_entities,
                                                tags__nin=self.__except_tags
                                                )[0:30]

        all_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            favicon=link.favicon,
            description=link.description
        ) for link in all_links]

        return all_links_list

    def fetch_most_click_links(self):
        if not self.it_is_me():
            return []

        most_click_links = []
        if not self.has_filter_tags():
            most_click_links = models.LinkPost.most_click_links(user=self.__user)
        else:
            most_click_links = models.LinkPost.most_click_links(user=self.__user,
                                                                tags__all=self.__filter_tags_entities)

        most_click_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            favicon=link.favicon,
            click_count=link.click_count
        ) for link in most_click_links]

        return most_click_links_list

    def fetch_latest_click_links(self):
        if not self.it_is_me():
            return []

        latest_click_links = []
        if not self.has_filter_tags():
            latest_click_links = models.LinkPost.latest_click_links(user=self.__user)
        else:
            latest_click_links = models.LinkPost.latest_click_links(user=self.__user,
                                                                    tags__all=self.__filter_tags_entities
                                                                    )

        latest_click_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            favicon=link.favicon,
            clicked_at=utils.totimestamp(link.clicked_at)
        ) for link in latest_click_links]

        return latest_click_links_list

    def fetch_never_click_links(self):
        if not self.it_is_me():
            return []

        never_click_links = []
        if not self.has_filter_tags():
            never_click_links = models.LinkPost.never_click_links(user=self.__user)
        else:
            never_click_links = models.LinkPost.never_click_links(user=self.__user,
                                                                  tags__all=self.__filter_tags_entities
                                                                  )

        never_click_links_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            favicon=link.favicon,
            clicked_at=utils.totimestamp(link.clicked_at)
        ) for link in never_click_links]

        return never_click_links_list


class IndexController:
    def __init__(self):
        pass

    def get_total_link_count_string(self):
        return "{:,}".format(len(models.LinkPost.objects()))

    def get_latest_add_links(self):
        links = models.LinkPost.objects()[0:10]
        link_list = [dict(
            id=str(link.id),
            title=link.title,
            url=link.url,
            favicon=link.favicon,
            description=link.description
        ) for link in links]
        return link_list

    def fetch_user_topics(self, user):
        all_tags = models.Tag.objects(user=user)
        all_topics_list = [dict(
            id=str(tag.id),
            name=tag.name
        ) for tag in all_tags if tag.is_topic]
        return all_topics_list

    def get_user_total_link_count_string(self,user):
        return "{:,}".format(len(models.LinkPost.objects(user=user)))

    def get_star_users(self):
        users = models.User.objects()
        users_list = [dict(
            blog_id=user.blog_id,
            github_url=user.github_url,
            github_name=user.github_name,
            avatar=user.github_avatar_url,
            topics=self.fetch_user_topics(user),
            link_count_string=self.get_user_total_link_count_string(user)
        ) for user in users]
        return users_list
