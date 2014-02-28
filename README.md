# lita-bitbucket-wehbhook

A Lita handler to send Bitbucket.org commit messages to the chat.

## Installation

Add lita-bitbucket-wehbhook to your Lita instance's Gemfile:

``` ruby
gem "lita-bitbucket-wehbhook"
```

## Configuration

You will need to add a Bitbucket Webhook url that points to: http://address.of.lita/bitbucket-webhook

How to setup a webhook in Bitbucket:

A repository administrator can enable hooks for a specific repository. Once you've configured a hook, it is active.

1. Go to the repository settings .
2. Click Services in the Additional options/settings section on the right-hand side of the screen.
On the page, you will see a dropdown list of services available. You may add as many services as you want. You can even add many instances of the same type. For example, you can email several people or ping several different URLs.
3. Select the POST service.
4. Click Add service.
The system adds the service to the page.
5. Scroll to the service you added.
6. Enter the URL of the lita-bitbucket-webhook.
7. Click Save.



## License

[MIT](http://opensource.org/licenses/MIT)