$folderPath = "C:\"  # İzlenmek istenen klasörün yolu
$filter = "*.*"                      # İzlenecek dosya türü filtresi
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderPath
$watcher.Filter = $filter
$watcher.IncludeSubdirectories = $true

# Dosya oluşturma, silme veya değiştirme durumlarında çağrılacak fonksiyon
$action = {
    $path = $Event.SourceEventArgs.FullPath
    $changeType = $Event.SourceEventArgs.ChangeType
    $timeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    $message = "$timeStamp -  Dosya: $path - Islem: $changeType"
    
    # Eyleme göre renk seçimi
    switch ($changeType) {
        "Created"  { Write-Host $message -ForegroundColor DarkYellow }
        "Deleted"  { Write-Host $message -ForegroundColor Red }
        "Changed"  { Write-Host $message -ForegroundColor Blue }
        "Renamed"  { Write-Host $message -ForegroundColor Green }
        default    { Write-Host $message }
    }
}

# Etkinlikleri tanımla
Register-ObjectEvent $watcher "Created" -Action $action
Register-ObjectEvent $watcher "Deleted" -Action $action
Register-ObjectEvent $watcher "Changed" -Action $action
Register-ObjectEvent $watcher "Renamed" -Action $action

# İzlemeyi başlat
$watcher.EnableRaisingEvents = $true

# İzlemeyi sonlandırmak istediğinizde aşağıdaki satırları kullanabilirsiniz:
# Unregister-Event -SourceIdentifier $watcher.Created
# Unregister-Event -SourceIdentifier $watcher.Deleted
# Unregister-Event -SourceIdentifier $watcher.Changed
# Unregister-Event -SourceIdentifier $watcher.Renamed
# $watcher.EnableRaisingEvents = $false
# $watcher.Dispose()