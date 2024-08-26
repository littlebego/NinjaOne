# NinjaOne
This is a series of helper functions I've written for interacting with the NinjaOne API. I made this to be used on an in-house server to automate certain documentation tasks.

Note: This is only for use on a single, in-house server to run scripts that talk to the API. I use it to automate global knowledgebase articles, WYSIWYG fields, etc. It's also pretty barebones: for example, I don't have support for anything other than the US instance. I'm more or less documenting this for my own use.

<h2>Ninja Setup:</h2>
1. Go to Administration > Devices > Role Custom Fields
2. Create two new secure fields:
   - Client ID (clientId)
   - Client Secret (clientSecret)
   - Make both:
     - Technician Editable (you'll change this to none later)
     - Automations Read
     - API Read
3. Go to Administration > Devices > Roles
4. Scroll down to "Windows Server" and add a new Role
5. Name it whatever you like, just make sure to add the two secure fields above to the new Role.
6. Go to Administration > Policies > Agent Policies
7. Create a new Policy for your server. Make sure Role is Windows Server
   - Note: I chose not to inherit any other policies to avoid confusion in scheduling.
8. Go to your server in Ninja (in my environment, we had our own organization setup)
9. In the device settings, change: Device Role & Policy to what you made before.
10. The server is pretty much ready to go now! Next we'll get the API credentials.
11. Go to Administration > Apps > API > Client App IDs > Add
12. Give it these settings:
    - Name it whatever your like (I named it based on my server)
    - Scopes: Check all three (Monitoring, Management, and Control)
    - Allowed Grant Types: Client Credentials
13. Go to your Server > Custom Fields and update both fields.
    - Note: These credentials give a ton of access into Ninja, so only keep them in a secure password manager (or Ninja itself.)
14. Copy the NinjaOne.ps1 script from this repository and put it on your server, for my examples, it's in:
    - C:\Scripting\NinjaOne\NinjaOne.ps1
   
<h2>Scripting:</h2>
When creating a new Powershell script in Ninja, make sure to add this to the top of your script:

	. 'C:/Scripting/NinjaOne/NinjaOne.ps1'

Then, you intialize the connection:

	$clientId = Ninja-Property-Get clientId<br>
	$clientSecret = Ninja-Property-Get clientSecret<br>
	Connect-NinjaOne $clientId $clientSecret<br>

Now that you're connected, you can do things like this:
   
	$orgs = Get-Organizations
	Write-Output $orgs[0]
