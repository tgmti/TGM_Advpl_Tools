cls

Function RotinaPrincipal() {

    Write-Host 'Verificando se é um diretório Git Válido'
    cd C:\TOTVS\TDS\WorkSpaces\TDS_Workspace_Mars_11.2\Transjoi_Copia_Producao

    $isGitDir = git status

    if ($isGitDir){
    
        If (MudaBranch Desenvolvimento) {
            Write-Host 'Faz Stash do Branch Desenvolvimento, para nao perder alteracoes nao comitadas'
            git stash

            If (MudaBranch master){
                Write-Host 'Juntar alterações do remote e fazer rebase de commits no repositório local'
                #TODO: Garantir que reconstrua 
                git pull origin master --rebase

                # Gerar log com os últimos arquivos alterados:
                git diff --name-only HEAD~ f0571c8523a1ce0e11855c5cc93bb98fe2937726
                #TODO: Retornar $true para ser utilizado em outros scripts
            }

        }

        #Write-Host 'Alterar para o Branch de desenvolvimento'
        #git checkout Desenvolvimento
        #$Status = (git branch)
        #If ( $Status.Contains('* Desenvolvimento') ){
        #    
        #} else {
        #    Write-Host ( 'Erro ao alterar o HEAD para o branch Desenvolvimento' + $Status )
        #}


    } else {
        Write-Host ( "Não é um diretório GIT válido: " + $isGitDir)
    }

}


Function MudaBranch($Local:branch){

    Write-Host 'Alterar para o Branch ' + $branch
    git checkout $branch
    $Local:Status = (git branch)

    If ( $Status.Contains('* ' + $branch) ){
        Return $true
    } else {
        Write-Host ( 'Erro ao alterar o HEAD para o branch ' + $branch )
        Return $false
    }

}

RotinaPrincipal