<ul>
<li>First we have to be a admin in order to integrate with Splunk. We can integrate with a non-admin account if we have a "Dev Console".</li> 
<li>We need to create a app in "Dev console" of Box account. To do so we need to login to box using developer console link.(Just Google "Box developer console")</li> 
	
<img width="960" alt="Untitled" src="https://user-images.githubusercontent.com/80450749/236737598-24722648-6cd0-4243-95df-89772a3822d2.png">

![image](https://user-images.githubusercontent.com/80450749/236737688-8b720f35-3ede-42c7-bc59-9947688ef687.png)
	
<li>Create a new app here as follows...	

![image](https://user-images.githubusercontent.com/80450749/236737921-9d8cb873-68a9-48ec-9fc0-87c78e9fae65.png)


<li>Select the appropriate way of authentication.
<li>Name the app as you wish, in my case I am giving Splunk
<li>Click on create app.
	
![image](https://user-images.githubusercontent.com/80450749/236738038-cd14a580-2bcc-467d-82e3-ca14e01d6100.png)

<li>Please make sure your screen looks like this.
<li>Now copy the Client ID and Client Secret.	

![image](https://user-images.githubusercontent.com/80450749/236738088-a39ce08e-70bd-4ba3-a4f7-666be62b7ad3.png)
	
![image](https://user-images.githubusercontent.com/80450749/236738140-96f6e596-1cbb-4494-b878-27bb6c95cf86.png)

![image](https://user-images.githubusercontent.com/80450749/236738161-908b180f-5213-4b77-93fa-03c21da6eebe.png)

![image](https://user-images.githubusercontent.com/80450749/236738182-d831d335-9ae2-42d7-94fe-dcabf382385f.png)

	
<li>Install Splunk add-on for Box in your splunk instance.
<li>Open the add-on.
<li>Add box account credentials in the configuration tab as shown below.

![image](https://user-images.githubusercontent.com/80450749/236738224-40e870bd-ce43-4ce4-9535-60b5ca828d4a.png)

![image](https://user-images.githubusercontent.com/80450749/236738246-79a0add5-7d42-425f-99a4-59005f157350.png)


<li>Enter you client ID and client secret and specify some unique name.
<li>Now add the input, and click add.
<li>A pop up will appear showing an error, which will contain a url as follows...

![image](https://user-images.githubusercontent.com/80450749/236738290-5b7f653d-a334-44a4-9410-d96156e2ffb9.png)

<li>Copy the highlighted url and add it to the redirect url in box app.	

![image](https://user-images.githubusercontent.com/80450749/236738331-4ba49440-3779-4d6e-81db-7aa565510c98.png)


<li>Once you add the input after adding the url you should be able to see the above window, now grant access and close the windows.
	
![image](https://user-images.githubusercontent.com/80450749/236738582-10f7983a-ffeb-4d5b-9491-6f60460290c3.png)

	
<li>Once you save the configuration you should add the inputs in the Splunk add-on.

![image](https://user-images.githubusercontent.com/80450749/236738610-1a69dddc-5298-4a49-b00f-04375f90b2d6.png)


<li>Add the inputs to box account, from location shown in the above screenshot.
<li>After you add inputs, you should be able to see the box logs in splunk.
<h1>"This is the way"<h1>
