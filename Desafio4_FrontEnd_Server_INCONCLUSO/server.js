const express = require("express");
const app = express();
const csv = require("@fast-csv/parse");
const fs = require('fs');
const path = require('path');

//criação da rota de requisição do user e resposta do server
app.get('/search', (req, res) => {

//captura do input
    let filtroRegex = new RegExp(req.query.q, "i");
    const resultado = [];

//leitura do .csv localizado na pasta "file"
    fs.createReadStream(path.resolve(__dirname, 'file', 'Relatorio_cadop.csv'))
    .pipe(csv.parse({ headers: true, delimiter: ";", encoding: "latin1", skipLines:2, quote:'"' }))
    
    .on('data', row => {
        for (let key in row){
            if (filtroRegex.test(row[key])){
                resultado.push(row);
                break;
            }
        }
    })
//caso dê algum erro na consulta
    .on('error', error => {
        return res.json({error: "Não foi possivel realizar a consulta."})
    })
//exportação do json com os resultados obtidos
    .on('end', rowCount => {
        return res.json(resultado);
    });
});

app.listen('5000', () => {
    console.log("Servidor funcionando.");
});
