def webscraping():
        import time
        import selenium
        from selenium import webdriver
        from selenium.webdriver.chrome.options import Options

        #Caminhos & URL
        srcRelativo = 'C:\\Users\\will1\\Desktop\\'
        dir = srcRelativo + 'Teste_Nivelamento_I.C\\files\\desafio1_arquivos'
        url = 'https://www.gov.br/ans/pt-br/assuntos/prestadores/padrao-para-troca-de-informacao-de-saude-suplementar-2013-tiss'


        #Definição de algumas preferencias para o Chrome Webdrive
        option = Options()
        option.headless = True #esconde os procedimento no browser
        prfcs = {"download.default_directory": dir, #mudar diretório
                "download.prompt_for_download": False, #auto-download
                "plugins.always_open_pdf_externally": True #não abrirá no chrome
                }
        option.add_experimental_option("prefs", prfcs)
        time.sleep(5)
        driver = webdriver.Chrome(chrome_options=option)
        time.sleep(5)

        driver.get(url)

        #Navegando até a obtenção do link .pdf
        time.sleep(5)
        acptcookie = driver.find_element_by_xpath('//*[@id="lgpd-cookie-banner-janela"]/div[2]/button').click();
        time.sleep(5)
        linkatualizado = driver.find_element_by_xpath("//*[@id='parent-fieldname-text']/p[@class='callout']/a").click();
        time.sleep(5)
        linkpdf = driver.find_element_by_xpath('//*[@id="parent-fieldname-text"]/div/table/tbody/tr[1]/td[3]/a').get_attribute('href');

        #Download
        driver.get(linkpdf)
        time.sleep(10)

        driver.quit()
webscraping()