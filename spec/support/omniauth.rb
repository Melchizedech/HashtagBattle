OmniAuth.config.test_mode = true

auth_hash = {
              'provider': 'twitter',
              'uid': '123545',
              'info': {'name': 'BattleHashtagUser'},
              'credentials': {'token': 'token', 'secret': 'secret'}
            }
OmniAuth.config.add_mock(:twitter, auth_hash)