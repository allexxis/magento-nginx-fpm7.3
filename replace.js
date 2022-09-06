const fs = require('fs');
const filePath = '/etc/nginx/sites-available/default';

fs.writeFileSync(
   'auth.json',
   JSON.stringify({
      'http-basic': {
         'repo.magento.com': {
            username: process.env.MAGENTO_USERNAME,
            password: process.env.MAGENTO_PASSWORD,
         },
      },
   })
);
fs.readFile(filePath, 'utf8', function (err, data) {
   if (err) {
      return console.log(err);
   }
   const result = data.replace(
      /{{MAGENTO_DOMAIN}}/g,
      process.env.MAGENTO_DOMAIN
   );

   fs.writeFile(filePath, result, 'utf8', function (err) {
      if (err) return console.log(err);
   });
});
