const details = [];
const consultation = { details };
const vehicles = [];

const client = {
  CI: '',
  first_name: '',
  last_name: '',
  phone_number: '',
  email: '',
  consultation,
  vehicles,
};
// state
let currentDetail = null;
let currentVehicle = null;

const buttonAttrs = (index, color) => ({
  id: index,
  class: 'btn btn-' + color,
  type: 'button',
  'data-bs-toggle': 'modal',
});

/**
 * @param {string} table_id
 * @param {CallableFunction} editFunc
 * @param {CallableFunction} deleteFunc
 */
const renderTable = (table_id, modalId, editFunc, deleteFunc, items) => {
  const table = document.getElementById(table_id);
  const tbody = document.createElement('tbody');
  table.children[1].remove();
  table.appendChild(tbody);
  for (let item of items) {
    const row = tbody.insertRow();
    Object.keys(item).forEach((key) => {
      if (key === 'model') {
        const vehicle = item[key];
        Object.keys(vehicle).forEach((key) => {
          const col = row.insertCell();
          const value = vehicle[key];
          col.innerHTML = value.length > 20 ? value.slice(0, 20) + ' ...' : value;
        });
        return;
      }
      const col = row.insertCell();
      if (key === 'id') {
        col.innerHTML = item[key] + 1;
        return;
      }

      const value = item[key];
      col.innerHTML = value.length > 20 ? value.slice(0, 20) + ' ...' : value;
    });
    const col = row.insertCell();
    col.className = 'text-end';
    const editButton = document.createElement('button');
    const deleteButton = document.createElement('button');
    Object.keys(buttonAttrs(item.id, 'primary')).forEach((key) => {
      editButton.setAttribute(key, buttonAttrs(item.id, 'primary')[key]);
      deleteButton.setAttribute(key, buttonAttrs(item.id, 'danger')[key]);
    });
    editButton.setAttribute('data-bs-target', modalId);
    editButton.innerHTML = '<i class="bi bi-pencil"></i>';
    editButton.onclick = editFunc;
    deleteButton.innerHTML = '<i class="bi bi-trash"></i>';
    deleteButton.onclick = deleteFunc;
    col.appendChild(editButton);
    col.appendChild(deleteButton);
  }
};

// Client
const clientForm = document.getElementById('clientForm');
clientForm.onchange = (evt) => {
  const key = evt.target.name;
  client[key] = String(evt.target.value);
};

// Details
document.getElementById('addDetail').onclick = (etv) => {
  currentDetail = null;
};

const detailForm = document.getElementById('detailForm');
detailForm.addEventListener('submit', (evt) => {
  if (evt.preventDefault) evt.preventDefault();

  const entries = new FormData(evt.target).entries();
  const detail = currentDetail || {};
  const index = currentDetail ? detail.id : details.length;
  detail.id = index;
  for (let entrie of entries) {
    const [key, value] = entrie;
    const element = evt.target.elements[key];
    detail[key] = value.trim();
    if (element.tagName !== 'SELECT') {
      element.value = '';
    }
  }

  if (!currentDetail) {
    details.push(detail);
  }
  renderTable('detailsTable', '#detailFormModal', updateDetail, removeDetail, details);

  return false;
});

const updateDetail = (evt) => {
  const button = evt.delegateTarget;
  const index = Number(button.id);
  currentDetail = details[index];
  console.log(currentDetail);
  const elementId = button.getAttribute('data-bs-target').replace('Modal', '');
  const form = document.querySelector(elementId);
  Object.keys(currentDetail).forEach((key) => {
    if (key === 'id') return;
    form.elements[key].value = currentDetail[key];
  });
};

const removeDetail = (evt) => {
  const button = evt.delegateTarget;
  const index = Number(button.id);
  details.splice(index);
  renderTable('detailsTable', '#detailFormModal', updateDetail, removeDetail, details);
};

// Vehicle table
document.getElementById('addVehicle').onclick = (etv) => {
  currentVehicle = null;
};

const vehicleForm = document.getElementById('vehicleForm');
vehicleForm.addEventListener('submit', (evt) => {
  console.log(evt);
  if (evt.preventDefault) evt.preventDefault();
  try {
    const entries = new FormData(evt.target).entries();
    const vehicle = currentVehicle || {};
    const index = currentVehicle ? vehicle.id : vehicles.length;
    vehicle.id = index;
    let modelKey = '';
    for (let entrie of entries) {
      const [key, value] = entrie;
      if (key === 'model_name') {
        modelKey = modelKey + value + '-';
        continue;
      }
      if (key === 'model_type') {
        modelKey = modelKey + value;
        continue;
      }
      const element = evt.target.elements[key];
      vehicle[key] = value.trim();
      if (element.tagName !== 'SELECT') {
        element.value = '';
      }
    }
    vehicle.model = models[modelKey];
    console.log(vehicle);

    if (!currentVehicle) {
      vehicles.push(vehicle);
    }
    renderTable('vehicleTable', '#vehicleFormModal', updateVehicle, removeVehicle, vehicles);

    return false;
  } catch (error) {
    console.error(error);
    return false;
  }
});

const updateVehicle = (evt) => {
  const button = evt.delegateTarget;
  const index = Number(button.id);
  currentVehicle = vehicles[index];
  console.log(currentVehicle);
  const elementId = button.getAttribute('data-bs-target').replace('Modal', '');
  const form = document.querySelector(elementId);
  Object.keys(currentVehicle).forEach((key) => {
    if (key === 'id') return;
    form.elements[key].value = currentVehicle[key];
  });
};

const removeVehicle = (evt) => {
  const button = evt.delegateTarget;
  const index = Number(button.id);
  vehicles.splice(index);
  renderTable('vehicleTable', '#vehicleFormModal', updateVehicle, removeVehicle, vehicles);
};

document.getElementById('saveClientButton').onclick = async (evt) => {
  try {
    const res = await fetch('/clients/add', {
      method: 'POST',
      body: JSON.stringify(client),
      headers: {
        'Content-Type': 'application/json',
      },
    });
    if (res.status === 201) {
      window.location.href = '/clients/done';
      return;
    }
    const data = await res.json();
    console.log(data);
    alert(data);
  } catch (error) {
    console.log(error);
    throw error;
  }
};
