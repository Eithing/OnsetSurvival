class Item {
    constructor(type, imageId, ammout) {
        //info sur l'item
        this.element = newEl('div');
        this.element.id = type.toString();

        this.element.classList.add('item');

        this.image = newEl('img');
        this.image.classList.add('item-image')
        this.image.src = "./../../Ressources/" + type + "/" + imageId + ".jpg"
        this.element.appendChild(this.image);

        this.label = newEl('label');
        if(ammout > 999)
        {
            ammout = "999+"
        }
        this.label.innerHTML = ammout.toString(); //set ammout in label
        this.label.classList.add('item-label')
        this.element.appendChild(this.label);

        return this;
    }
}