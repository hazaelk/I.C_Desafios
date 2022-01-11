def transformar_dados():
        import os
        import Desafio1_WebScraping
        import tabula as tb
        import pandas as pd
        import zipfile
        import time

        srcRelativo = 'C:\\Users\\will1\\Desktop\\'
        arquivo = srcRelativo + 'Teste_Nivelamento_I.C\\files\\desafio1_arquivos\\padrao-tiss_componente-organizacional_202111.pdf'
        dir = srcRelativo + 'Teste_Nivelamento_I.C\\files\\desafio2_arquivos\\'

        statuspdf = os.path.isfile(arquivo)
        #Se não houver o pdf ele executará o webscraping importado.
        if not statuspdf:
                Desafio1_WebScraping.webscraping()

        #---------Obtenção de dados do pdf para os respectivos quadros
        quadroX = tb.read_pdf(arquivo, pages="114")[0]
        quadroY = tb.read_pdf(arquivo, pages="115,116,117,118,119,120")[0:-1]
        quadroZ = tb.read_pdf(arquivo, pages="120")[-1]

        #---------Passando para Data Frames
        quadro30 = pd.DataFrame(quadroX)
        quadro31 = pd.DataFrame(quadroY)
        quadro32 = pd.DataFrame(quadroZ)

        #---------Transformando em CSV
        quadro30.to_csv(dir + 'quadro30.csv', encoding='utf-8')
        quadro31.to_csv(dir + 'quadro31.csv', encoding='utf-8')
        quadro32.to_csv(dir + 'quadro32.csv', encoding='utf-8')
        time.sleep(5)

        #---------Zipando arquivos
        zipar = zipfile.ZipFile(dir + 'Teste_Willian.zip','x',zipfile.ZIP_DEFLATED)
        #O modo 'x', passado como parâmetro, criará e escreverá um novo arquivo.
        zipar.write('Transformacao_de_Dados\\quadro30.csv')
        zipar.write('Transformacao_de_Dados\\quadro31.csv')
        zipar.write('Transformacao_de_Dados\\quadro32.csv')
        time.sleep(5)
        zipar.close()
transformar_dados()