---
layout: default
parent: Northbound
title: System Notification (Webhooks)
nav_order: 4
---
# System Notification 

EdgeLake provides services like _REST_, _SMS_ and _STMP_ (eMail) in order allow your network to send notifications regarding 
the system; this can be things like CPU utilization, data not coming in or simply when ever a partition is being dropped / created.


## Setting up Webhooks

_Webhooks_ are user-defined _HTTP_ callbacks that enable real-time communication between web applications; they are the
simplest and fastest way to send messages into third-party applications as it simply uses a _REST_ (post) request as 
opposed to needing to develop a full application for messaging.

* [Slack](https://api.slack.com/messaging/webhooks)
* [Discord](https://docs.gitlab.com/ee/user/project/integrations/discord_notifications.html#create-webhook)
* [Microsoft Teams](https://learn.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook?tabs=newteams%2Cdotnet)
* [Google Hangouts](https://developers.google.com/workspace/chat/quickstart/webhooks)


### Steps
<ol start="1">
    <li>Go to <a href="https://api.slack.com/apps/" target="_blank">Slack Applications Sections</a> (may require to login 
        / admin permissions)
    </li>
    <li>Under _Create_, Create an app from manifest
        <table>
            <tr>
                <td align="center"><img src="../../../imgs/notification_slack_your_app.png" height="75%" width="75%" /></td>
                <td align="center"><img src="../../../imgs/notification_slack_manifest.png" height="75%" width="75%" /></td>
            </tr>
        </table>
    </li>
    <li>Select the preferred channel
        <div class="image-frame"><img src="../../../imgs/notification_slack_workspace.png" /></div>
    </li>
    <li>Press continue / next till the end</li>
    <li>Select <i>Incoming Webhooks</i>
        <div class="image-frame"><img src="../../../imgs/notification_slack_webhook.png" /></div>
    </li>
    <li>Enable Webhooks
        <div class="image-frame"><img src="../../../imgs/notification_slack_enable_webhooks.png" /></div>
    </li>
    <li>At the bottom, add <i>Webbooks</i> to workspace
        <div class="image-frame"><img src="../../../imgs/notification_slack_create_webhook.png" /></div>
    </li>
    <li>Select which channel in Slack to send messages to
        <div class="image-frame"><img src="../../../imgs/notification_slack_select_channel.png" /></div>
    </li>
    <li>When done you should see a <i>Webhook</i> (URL) - this will be used as part of your REST request in EdgeLake
        <div class="image-frame"><img src="../../../imgs/notification_slack_webhook_generated.png" /></div>
    </li>
</ol>

**Generated URL**: 
<pre class="code-frame"><code class="language-shell">https://hooks.slack.com/services/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</code></pre>


## Send Notifications via EdgeLake

### Slack Webhooks
EdgeLake allows to send cURL requests the [_rest_ command](../anylog%20commands.md#rest-command). Since _Webhooks_ are 
essentially URLs to send messages into a system, we'll be using the _rest_ command to send notifictaions from EdgeLake into
Slack.

1. Create webhook URL as a variable 
```anylog
webhook_url = "https://hooks.slack.com/services/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"
```

2. get percentage of CPU used and current timestamp  
```anylog
cpu_percent = get node info cpu_percent
date_time = python "datetime.datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S.%f')"
```

3. Create payload
```anylog
text_msg = !date_time + "  CPU usage: " + !cpu_percent 
payload = json {"text": !text_msg}
```

4. Publish information to Slack via _REST_
```anylog
rest post where url = !webhook_url and body = !payload and headers = "{'Content-Type': 'application/json'}" 
```

Once sent, an output would appear in the proper Slack channel

<img src="../../../imgs/notification_slack_messsage.png"  height="50%" width="50%" />

**Note**: _Google Hangouts_, _Discord_ and _Microsoft Teams_ use `content` for the _payload_ key as opposed to `text`. 


