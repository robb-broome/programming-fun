require 'rspec'
require 'json'

class Standup

  attr_reader :standup_data
  def initialize(standup_data:)
    @standup_data = standup_data
  end

  def mapped_standup_data
    # events are here
    standup_data.map do |standup_event|
      event_type = standup_event['type']
      if event_type == 'PushEvent'
        {type: 'github.commit',
         date: standup_event['created_at'],
         content: {
           repo: standup_event['repo']['name']
         }
        }
      end
    end.compact
  end
end

# github.PushEvent:
#   created_at: date
#   repo.name: content.repo
#   date -> created_at



RSpec.describe Standup do
  let(:push_event) do
    '[
  {
    "id": "9426158080",
    "type": "PushEvent",
    "actor": {
      "id": 353134,
      "login": "hex337",
      "display_login": "hex337",
      "gravatar_id": "",
      "url": "https://api.github.com/users/hex337",
      "avatar_url": "https://avatars.githubusercontent.com/u/353134?"
    },
    "repo": {
      "id": 176839218,
      "name": "hex337/pager-duty-report",
      "url": "https://api.github.com/repos/hex337/pager-duty-report"
    },
    "payload": {
      "push_id": 3499375242,
      "size": 1,
      "distinct_size": 1,
      "ref": "refs/heads/master",
      "head": "6709919fca8a112166e30791ac29a654927d5018",
      "before": "0bd8286d1ff5d398baab1094efcdd72235cdcef5",
      "commits": [
        {
          "sha": "6709919fca8a112166e30791ac29a654927d5018",
          "author": {
            "email": "hex337@gmail.com",
            "name": "Alex"
          },
          "message": "Fixed formatting and pulled things from a config file (#3)\n\n- Include example config file\r\n- Add stats, still need histogram",
          "distinct": true,
          "url": "https://api.github.com/repos/hex337/pager-duty-report/commits/6709919fca8a112166e30791ac29a654927d5018"
        }
      ]
    },
    "public": true,
    "created_at": "2019-04-11T17:50:18Z" }
]'
  end
  it 'works' do
    puts JSON.parse(push_event)
  end

  it 'maps push events' do
    data = JSON.parse push_event
    puts Standup.new(standup_data: data).mapped_standup_data

  end
end

