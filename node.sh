## docker 提前从gcr的国内仓库里拉取kubernetes的核心image, 并修改为原image的tag
echo "################## installing kubernetes images"
curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/k8s-node-images | while IFS='=' read -r key value
do
  #echo "${key}=${value}"
  if [[ -z $(sudo docker images | grep ${key%:*}) ]]
  then
    sudo docker pull ${value}
    sudo docker tag ${value} ${key}
    sudo docker rmi ${value}
  fi
done
echo "installed kubernetes images ##################"