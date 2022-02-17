## Ontodocs Auto-Deployment

Previously, documentation for new releases of *CASE* would have to be manually built using gendocs/ontodocs. With this repository, building the documentation and deploying it on the web will be a more automated process, and allow for local documentation to be built for necessary cases.



#### Deployment

###### Configuration

To deploy, the system will need to have **Apache2** installed and this repository cloned on it. We will be taking advantage of *Apache2's VirtualHost* capablity and *mod_rewrite* to help route traffic to the proper documentation pages. This CONTRIBUTE.md page will outline installing **Apache2** and utilizing the **Makefile** to test the setup. All commands will assume the deployment system is a debian-based system *(such as Ubuntu)*.



First, update the package repositories and update the system:

```bash
$ sudo apt-get update
$ sudo apt-get -y upgrade
```

Then, install Apache2 on the server:

```bash
$ sudo apt-get install apache2
```



Once Apache2 is installed, we are going to want to enable *mod_rewrite* and disable the default website that is displayed at *localhost*

```bash
# enable mod_rewrite, without manually editing /etc/apache/apache2.conf
$ sudo a2enmod mod_rewrite
# disable the default website
$ sudo a2dissite 000-default.conf
# finally, restart the apache service
$ sudo service apache2 restart
```



We can confirm that *mod_rewrite* is running:

```bash
$ sudo apache2ctl -M | grep mod_rewrite
```



Now that we have enabled *mod_rewrite*, we can create the *VirtualHost* for the documentation website:

```bash
$ sudo vi /etc/apache2/sites-available/case-docs.conf
```

Inside this file, we can include the following configuration:

```shell
<VirtualHost *:80>
		# replace the ServerName with your domain
    ServerName example.com
    
    # replace the DocumentRoot with the path to the repo
    DocumentRoot /path/to/files
    
    ServerAdmin webmaster@localhost
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

		# replace the path in the <Directory> directive with the path to the repo
    <Directory /path/to/files>
      Options Indexes FollowSymLinks
      AllowOverride All
      Require all granted
    </Directory>
</VirtualHost>
```

This configuration will define a `ServerName`, which is the domain name that the server will listen for and the `DocumentRoot`, which is the path to the files. You will also need to modify the path in the `<Directory></Directory>` directive to enable the proper **.htaccess** settings needed for *mod_rewrite*.



Finally, enable the new website then restart apache:

```bash
$ sudo a2ensite case-docs.conf
$ sudo service apache2 restart
```



###### Optional Localhost

If you are running the deployment on a system that does not access the internet, or you wish to only provide the documentation locally, you may want to add an entry to your hosts file.

```bash
$ sudo vi /etc/hosts
```



###### Debugging

There are a variety of errors that you can face, but we are going to address the most common ones. 

**404** - For 404 errors, check to ensure that the permissions are properly set on the folder and files. For this, we will use the example directory `/srv/http/case-docs/public`:

```bash
$ sudo find /srv/http/case-docs/public -type d -exec chmod 775 {} \;
$ sudo find /srv/http/case-docs/public -type f -exec chmod 664 {} \;
$ sudo chown -R www-data:www-data /srv/http/case-docs/public
```

**500** - For any 500 errors, the server may be mis-configured, you can check the following areas to see if there is relevant outputs. This is commonly due to `/etc/apache/apache.conf` being mis-configured, or a typo in one of the sites which are enabled.

```bash
$ sudo tail -f /var/log/apache/error.log
$ journalctl # or check -u apache2
```



#### Testing

To test the deployment, run the **Makefile** to ensure expected URL behaviors and content types. If you have set the VirtualHost on apache as anything besides 'localhost', you will want to alter the URL specified in this script.

```bash
$ make check-service
```