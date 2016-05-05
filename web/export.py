import os
import django

os.environ['DJANGO_SETTINGS_MODULE'] = 'iosblog.settings'
django.setup()

from x123.models import Domain
import json

target_json_dir = '/Users/everettjf/GitHub/everettjf.github.com/app/blogreader/'
target_markdown_dir = '/Users/everettjf/GitHub/iOSBlog/'

########################################################


# Json export
def export_json():
    # Domain
    with open(os.path.join(target_json_dir, 'domain.json'), 'w+') as f:
        res_domains = []
        for domain in Domain.objects.all():
            res_domains.append({
                'id': domain.id,
                'name': domain.name
            })
        json.dump(res_domains, f)

    # Aspect
    # with open



########################################################
if __name__ == '__main__':
    export_json()

