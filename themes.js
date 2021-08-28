const util = require('util');
const exec = util.promisify(require('child_process').exec);
const config = require('./themes.json');
const themes = config.themes;

async function install() {
   try {
      if (themes.length === 0) {
         console.log(`Compiling everything... \n`);
         const { stdout, stderr } = await exec(
            `bin/magento setup:static-content:deploy -f`
         );
         console.log(stdout);
         console.log(stderr);
      } else {
         themes.forEach(async (theme, index) => {
            let langs = '';
            theme.langs.forEach((lang) => {
               langs += lang + ' ';
            });
            console.log(
               `Compiling... theme=${theme.name} area=${theme.area} languages=${langs} \n`
            );
            const { stdout, stderr } = await exec(
               `bin/magento setup:static-content:deploy ${langs} --area ${theme.area}  --theme ${theme.name} -f`
            );
            console.log(stdout);
            console.log(stderr);
         });
      }
   } catch (error) {
      console.error(error);
   }
}
install();
